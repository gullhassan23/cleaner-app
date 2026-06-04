import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:cleaner_app/l10n/l10n_get.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_compress/video_compress.dart';

import '../../models/compress/compress_entities.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../photo_library/photo_library_use_cases.dart';

class MediaCompressionService {
  MediaCompressionService({
    required LoadOriginalFileUseCase loadOriginalFileUseCase,
  }) : _loadOriginalFileUseCase = loadOriginalFileUseCase;

  final LoadOriginalFileUseCase _loadOriginalFileUseCase;

  Future<void> cancelOngoingCompression() async {
    try {
      await VideoCompress.cancelCompression();
    } catch (_) {
      // Ignore cancellation failures; session controller still stops the queue.
    }
  }

  Future<CompressedMediaResultEntity> compressAsset(
    PhotoAssetEntity asset, {
    required CompressionQualityPreset quality,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final sourceFile = await _loadOriginalFileUseCase(asset.id);
      if (sourceFile == null || !await sourceFile.exists()) {
        return CompressedMediaResultEntity(
          assetId: asset.id,
          mediaType: asset.mediaType,
          originalBytes: asset.fileSize,
          compressedBytes: 0,
          outputPath: '',
          errorMessage: getL10n().compressOriginalUnavailable,
        );
      }

      final originalBytes = await sourceFile.length();
      final outputDirectory = await _ensureOutputDirectory();
      if (asset.isVideo) {
        return _compressVideo(
          asset,
          sourceFile: sourceFile,
          originalBytes: originalBytes,
          quality: quality,
          onProgress: onProgress,
        );
      }

      return _compressImage(
        asset,
        sourceFile: sourceFile,
        originalBytes: originalBytes,
        outputDirectory: outputDirectory,
        quality: quality,
        onProgress: onProgress,
      );
    } catch (error) {
      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: asset.fileSize,
        compressedBytes: 0,
        outputPath: '',
        errorMessage: getL10n().compressCompressionFailed('$error'),
      );
    }
  }

  Future<Directory> _ensureOutputDirectory() async {
    final baseDirectory = await getTemporaryDirectory();
    final outputDirectory = Directory(
      path.join(baseDirectory.path, 'compressed_media'),
    );
    if (!await outputDirectory.exists()) {
      await outputDirectory.create(recursive: true);
    }
    return outputDirectory;
  }

  Future<CompressedMediaResultEntity> _compressImage(
    PhotoAssetEntity asset, {
    required File sourceFile,
    required int originalBytes,
    required Directory outputDirectory,
    required CompressionQualityPreset quality,
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(0.05);
    final targetPath = path.join(
      outputDirectory.path,
      '${_baseName(sourceFile.path)}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      sourceFile.absolute.path,
      targetPath,
      quality: quality.imageQuality,
      format: CompressFormat.jpeg,
      keepExif: true,
    );
    onProgress?.call(0.7);

    if (compressedFile == null) {
      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: originalBytes,
        compressedBytes: 0,
        outputPath: '',
        errorMessage: getL10n().compressUnableCompressSelected,
      );
    }

    final outputFile = File(compressedFile.path);

    try {
      final savedAsset = await PhotoManager.editor.saveImageWithPath(
        outputFile.path,
        title: _compressedTitle(asset.title, '.jpg'),
        relativePath: _relativePathFor(asset),
        creationDate: DateTime.now(),
      );
      final savedFile = await _resolveSavedFile(savedAsset, outputFile);
      final savedBytes = await savedFile.length();
      final compressedBytes = math.min(savedBytes, await outputFile.length());
      onProgress?.call(1.0);

      final baselineBytes = asset.fileSize > 0 ? asset.fileSize : originalBytes;

      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: baselineBytes,
        compressedBytes: compressedBytes,
        outputPath: savedFile.path,
      );
    } finally {
      if (await outputFile.exists()) {
        await outputFile.delete();
      }
    }
  }

  Future<CompressedMediaResultEntity> _compressVideo(
    PhotoAssetEntity asset, {
    required File sourceFile,
    required int originalBytes,
    required CompressionQualityPreset quality,
    void Function(double progress)? onProgress,
  }) async {
    Subscription? progressSubscription;

    try {
      final sourceInfo = await VideoCompress.getMediaInfo(sourceFile.path);
      final maxDimension = _sourceMaxDimension(sourceInfo);
      final attempt = _videoCompressionAttempt(quality, maxDimension);

      developer.log(
        'Starting single-pass video compression '
        'assetId=${asset.id} preset=${quality.label} '
        'targetSavingsPercent=${quality.savingsPercent}% '
        'sourceMaxDimension=$maxDimension '
        'videoQuality=${attempt.quality} frameRate=${attempt.frameRate} '
        'profile=${attempt.profileLabel}',
        name: 'MediaCompressionService',
      );

      var lastReportedProgress = -1.0;
      progressSubscription = VideoCompress.compressProgress$.subscribe((event) {
        final normalized = (event / 100).clamp(0.0, 1.0);
        if (lastReportedProgress >= 0.5 && normalized < 0.1) {
          developer.log(
            'Video compress progress restarted assetId=${asset.id} '
            'previous=$lastReportedProgress current=$normalized',
            name: 'MediaCompressionService',
            level: 900, // warning
          );
        } else if (normalized == 0 || normalized >= 1 || event % 25 == 0) {
          developer.log(
            'Video compress progress assetId=${asset.id} '
            'event=$event normalized=$normalized',
            name: 'MediaCompressionService',
          );
        }
        lastReportedProgress = normalized;
        onProgress?.call(normalized);
      });
      onProgress?.call(0.0);

      final baselineBytes = asset.fileSize > 0 ? asset.fileSize : originalBytes;

      final mediaInfo = await VideoCompress.compressVideo(
        sourceFile.path,
        quality: attempt.quality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: attempt.frameRate,
      );

      final compressedPath = mediaInfo?.path;

      if (compressedPath == null || compressedPath.isEmpty) {
        developer.log(
          'Video compression produced no output assetId=${asset.id}',
          name: 'MediaCompressionService',
        );
        return CompressedMediaResultEntity(
          assetId: asset.id,
          mediaType: asset.mediaType,
          originalBytes: baselineBytes,
          compressedBytes: 0,
          outputPath: '',
          errorMessage: getL10n().compressUnableCompressSelected,
        );
      }

      developer.log(
        'Video compression finished assetId=${asset.id} tempPath=$compressedPath',
        name: 'MediaCompressionService',
      );

      final compressedFile = File(compressedPath);
      final tempBytes = await compressedFile.length();
      final savedAsset = await PhotoManager.editor.saveVideo(
        compressedFile,
        title: _compressedTitle(
          asset.title,
          path.extension(compressedPath).isEmpty
              ? '.mp4'
              : path.extension(compressedPath),
        ),
        relativePath: _relativePathFor(asset),
        creationDate: DateTime.now(),
      );
      final savedFile = await _resolveSavedFile(savedAsset, compressedFile);
      final savedBytes = await savedFile.length();
      final compressedBytes = math.min(tempBytes, savedBytes);
      onProgress?.call(1.0);

      final reductionPercent = baselineBytes > 0
          ? ((1 - compressedBytes / baselineBytes) * 100).round()
          : 0;
      developer.log(
        'Video saved to gallery assetId=${asset.id} '
        'preset=${quality.label} profile=${attempt.profileLabel} '
        'originalBytes=$baselineBytes compressedBytes=$compressedBytes '
        'sizeReductionPercent=$reductionPercent%',
        name: 'MediaCompressionService',
      );

      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: baselineBytes,
        compressedBytes: compressedBytes,
        outputPath: savedFile.path,
      );
    } catch (error) {
      developer.log(
        'Video compression failed assetId=${asset.id} error=$error',
        name: 'MediaCompressionService',
        error: error,
      );
      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: asset.fileSize > 0 ? asset.fileSize : originalBytes,
        compressedBytes: 0,
        outputPath: '',
        errorMessage: getL10n().compressCompressionFailed('$error'),
      );
    } finally {
      progressSubscription?.unsubscribe();
      await VideoCompress.deleteAllCache();
    }
  }

  int _sourceMaxDimension(MediaInfo info) {
    final width = info.width ?? 0;
    final height = info.height ?? 0;
    if (width <= 0 || height <= 0) {
      return 720;
    }
    return math.max(width, height);
  }

  /// Picks one encoder profile up front. `video_compress` exposes a single
  /// progress stream, so retrying with additional passes would restart the UI
  /// from 0% and can invalidate temp files via [VideoCompress.deleteAllCache].
  ///
  /// Preset names reflect compression strength (Low/Medium/High), not output
  /// quality. Higher presets use lower resolutions and frame rates.
  _VideoCompressAttempt _videoCompressionAttempt(
    CompressionQualityPreset preset,
    int maxDimension,
  ) {
    switch (preset) {
      case CompressionQualityPreset.low:
        // ~20% size reduction — light downscale only.
        if (maxDimension > 960) {
          return const _VideoCompressAttempt(
            VideoQuality.Res640x480Quality,
            24,
            'low-640x480@24',
          );
        }
        return const _VideoCompressAttempt(
          VideoQuality.LowQuality,
          24,
          'low-native@24',
        );
      case CompressionQualityPreset.medium:
        // ~50% size reduction — stronger than [low] (640x480), weaker than [high].
        if (maxDimension > 1920) {
          return const _VideoCompressAttempt(
            VideoQuality.LowQuality,
            24,
            'medium-360p@24-4k',
          );
        }
        if (maxDimension > 960) {
          return const _VideoCompressAttempt(
            VideoQuality.LowQuality,
            24,
            'medium-360p@24',
          );
        }
        return const _VideoCompressAttempt(
          VideoQuality.LowQuality,
          20,
          'medium-native@20',
        );
      case CompressionQualityPreset.high:
        // ~80% size reduction — lowest resolution cap and frame rate.
        return const _VideoCompressAttempt(
          VideoQuality.LowQuality,
          15,
          'high-360p@15',
        );
    }
  }

  String _baseName(String filePath) {
    return path.basenameWithoutExtension(filePath).replaceAll(' ', '_');
  }

  String _compressedTitle(String? originalTitle, String fallbackExtension) {
    final safeOriginal =
        (originalTitle == null || originalTitle.trim().isEmpty)
            ? 'compressed_${DateTime.now().millisecondsSinceEpoch}$fallbackExtension'
            : originalTitle.trim();
    final baseName = path.basenameWithoutExtension(safeOriginal);
    final extension =
        path.extension(safeOriginal).isEmpty
            ? fallbackExtension
            : path.extension(safeOriginal);
    return '${baseName}_compressed$extension';
  }

  String _relativePathFor(PhotoAssetEntity asset) {
    const fallbackVideo = 'Movies/Cleaner';
    const fallbackImage = 'Pictures/Cleaner';
    final raw = asset.relativePath?.trim();
    if (raw == null || raw.isEmpty) {
      return asset.isVideo ? fallbackVideo : fallbackImage;
    }
    final normalized = raw
        .replaceAll('\\', '/')
        .replaceFirst(RegExp(r'^/+'), '');
    if (normalized.isEmpty) {
      return asset.isVideo ? fallbackVideo : fallbackImage;
    }
    final primary = normalized.split('/').first.toLowerCase();
    const allowedRoots = {'dcim', 'movies', 'pictures'};
    if (!allowedRoots.contains(primary)) {
      return asset.isVideo ? fallbackVideo : fallbackImage;
    }
    return normalized;
  }

  Future<File> _resolveSavedFile(AssetEntity savedAsset, File fallback) async {
    final savedFile = await savedAsset.originFile ?? await savedAsset.file;
    return savedFile ?? fallback;
  }
}

class _VideoCompressAttempt {
  const _VideoCompressAttempt(
    this.quality,
    this.frameRate, [
    this.profileLabel = 'unknown',
  ]);

  final VideoQuality quality;
  final int frameRate;
  final String profileLabel;
}
