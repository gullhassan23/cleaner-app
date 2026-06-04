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
import '../../utils/bytes_formatter.dart';
import '../photo_library/photo_library_use_cases.dart';

class MediaCompressionService {
  MediaCompressionService({
    required LoadOriginalFileUseCase loadOriginalFileUseCase,
  }) : _loadOriginalFileUseCase = loadOriginalFileUseCase;

  static const double _targetSizeTolerance = 0.12;
  static const int _maxVideoEncodeAttempts = 3;

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

      _printCompressionSummary(
        quality: quality,
        mediaType: 'Image',
        originalBytes: baselineBytes,
        compressedBytes: compressedBytes,
      );

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
      final baselineBytes = asset.fileSize > 0 ? asset.fileSize : originalBytes;
      final targetBytes = quality.targetBytesFor(baselineBytes);
      final ladder = _videoProfileLadder(maxDimension);

      developer.log(
        'Starting percentage-target video compression '
        'assetId=${asset.id} preset=${quality.label} '
        'targetKeepPercent=${quality.targetKeepPercent}% '
        'targetBytes=$targetBytes originalBytes=$baselineBytes '
        'sourceMaxDimension=$maxDimension ladderProfiles=${ladder.length}',
        name: 'MediaCompressionService',
      );

      var lastReportedProgress = -1.0;
      var activePass = 0;
      progressSubscription = VideoCompress.compressProgress$.subscribe((event) {
        final passProgress = (event / 100).clamp(0.0, 1.0);
        final normalized =
            ((activePass + passProgress) / _maxVideoEncodeAttempts).clamp(0.0, 1.0);
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
            'pass=$activePass event=$event normalized=$normalized',
            name: 'MediaCompressionService',
          );
        }
        lastReportedProgress = normalized;
        onProgress?.call(normalized);
      });
      onProgress?.call(0.0);

      final encodeResult = await _compressVideoTowardTarget(
        sourcePath: sourceFile.path,
        quality: quality,
        baselineBytes: baselineBytes,
        targetBytes: targetBytes,
        ladder: ladder,
        onEncodePass: (passIndex) => activePass = passIndex,
      );

      if (encodeResult == null) {
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

      final compressedPath = encodeResult.path;
      final attempt = encodeResult.attempt;

      developer.log(
        'Video compression finished assetId=${asset.id} '
        'tempPath=$compressedPath profile=${attempt.profileLabel} '
        'attempts=${encodeResult.attempts} outputBytes=${encodeResult.bytes}',
        name: 'MediaCompressionService',
      );

      final compressedFile = File(compressedPath);
      final tempBytes = encodeResult.bytes;
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

      _printCompressionSummary(
        quality: quality,
        mediaType: 'Video',
        originalBytes: baselineBytes,
        compressedBytes: compressedBytes,
        profile: attempt.profileLabel,
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

  void _printCompressionSummary({
    required CompressionQualityPreset quality,
    required String mediaType,
    required int originalBytes,
    required int compressedBytes,
    String? profile,
  }) {
    final savedBytes =
        originalBytes > compressedBytes ? originalBytes - compressedBytes : 0;
    final actualCompressionPercent = originalBytes > 0
        ? ((1 - compressedBytes / originalBytes) * 100).round()
        : 0;
    final profileSuffix = profile == null ? '' : ' | Encoder: $profile';
    final keepPercent = originalBytes > 0
        ? ((compressedBytes / originalBytes) * 100).round()
        : 0;
    final message =
        '[Compress Complete] $mediaType | '
        'User selected: ${quality.label.toUpperCase()} '
        '(target ${quality.targetKeepPercent}% of original size) | '
        'Original: ${BytesFormatter.humanize(originalBytes)} → '
        'After compress: ${BytesFormatter.humanize(compressedBytes)} | '
        'Saved: ${BytesFormatter.humanize(savedBytes)} | '
        'Output is $keepPercent% of original '
        '(target ${quality.targetKeepPercent}%, '
        '$actualCompressionPercent% bytes removed)$profileSuffix';

    // ignore: avoid_print
    print(message);
    developer.log(message, name: 'MediaCompressionService');
  }

  int _sourceMaxDimension(MediaInfo info) {
    final width = info.width ?? 0;
    final height = info.height ?? 0;
    if (width <= 0 || height <= 0) {
      return 720;
    }
    return math.max(width, height);
  }

  /// Mild → aggressive encoder profiles for the current source resolution.
  List<_VideoCompressAttempt> _videoProfileLadder(int maxDimension) {
    final ladder = <_VideoCompressAttempt>[];
    if (maxDimension > 1920) {
      ladder.add(
        const _VideoCompressAttempt(
          VideoQuality.Res1920x1080Quality,
          30,
          'ladder-1080p@30',
        ),
      );
    }
    if (maxDimension > 1280) {
      ladder.add(
        const _VideoCompressAttempt(
          VideoQuality.Res1280x720Quality,
          30,
          'ladder-720p@30',
        ),
      );
    }
    if (maxDimension > 960) {
      ladder.add(
        const _VideoCompressAttempt(
          VideoQuality.Res960x540Quality,
          24,
          'ladder-540p@24',
        ),
      );
    }
    if (maxDimension > 640) {
      ladder.add(
        const _VideoCompressAttempt(
          VideoQuality.Res640x480Quality,
          24,
          'ladder-480p@24',
        ),
      );
    }
    ladder.addAll(const [
      _VideoCompressAttempt(VideoQuality.MediumQuality, 30, 'ladder-medium@30'),
      _VideoCompressAttempt(VideoQuality.MediumQuality, 24, 'ladder-medium@24'),
      _VideoCompressAttempt(VideoQuality.LowQuality, 24, 'ladder-low@24'),
      _VideoCompressAttempt(VideoQuality.LowQuality, 15, 'ladder-low@15'),
    ]);
    return ladder;
  }

  int _initialLadderIndex(
    CompressionQualityPreset preset,
    int ladderLength,
  ) {
    if (ladderLength <= 1) {
      return 0;
    }
    switch (preset) {
      case CompressionQualityPreset.high:
        return 0;
      case CompressionQualityPreset.medium:
        return ((ladderLength - 1) * 0.45).round();
      case CompressionQualityPreset.low:
        return ladderLength - 1;
    }
  }

  bool _isWithinTargetBand(int outputBytes, int targetBytes) {
    if (targetBytes <= 0) {
      return false;
    }
    final delta = (outputBytes - targetBytes).abs() / targetBytes;
    return delta <= _targetSizeTolerance;
  }

  Future<_VideoEncodeResult?> _compressVideoTowardTarget({
    required String sourcePath,
    required CompressionQualityPreset quality,
    required int baselineBytes,
    required int targetBytes,
    required List<_VideoCompressAttempt> ladder,
    required void Function(int passIndex) onEncodePass,
  }) async {
    if (ladder.isEmpty) {
      return null;
    }

    final targetRatio = quality.estimatedOutputRatio;
    var index = _initialLadderIndex(quality, ladder.length);
    _VideoEncodeResult? closest;
    var attempts = 0;

    while (attempts < _maxVideoEncodeAttempts) {
      onEncodePass(attempts);
      if (attempts > 0) {
        await VideoCompress.deleteAllCache();
      }
      final attempt = ladder[index.clamp(0, ladder.length - 1)];
      final encoded = await _runSingleVideoEncode(
        sourcePath: sourcePath,
        attempt: attempt,
      );
      attempts++;

      if (encoded == null) {
        break;
      }

      final outputRatio = encoded.bytes / baselineBytes;
      final distance = (outputRatio - targetRatio).abs();
      if (closest == null || distance < closest.distanceToTarget) {
        closest = _VideoEncodeResult(
          path: encoded.path,
          bytes: encoded.bytes,
          attempt: attempt,
          attempts: attempts,
          distanceToTarget: distance,
        );
      }

      developer.log(
        'Encode attempt $attempts/${_maxVideoEncodeAttempts} '
        'profile=${attempt.profileLabel} '
        'outputBytes=${encoded.bytes} targetBytes=$targetBytes '
        'outputRatio=${(outputRatio * 100).toStringAsFixed(1)}% '
        'targetRatio=${(targetRatio * 100).toStringAsFixed(1)}%',
        name: 'MediaCompressionService',
      );

      if (_isWithinTargetBand(encoded.bytes, targetBytes)) {
        return _VideoEncodeResult(
          path: encoded.path,
          bytes: encoded.bytes,
          attempt: attempt,
          attempts: attempts,
          distanceToTarget: distance,
        );
      }

      if (encoded.bytes > targetBytes && index < ladder.length - 1) {
        index++;
        continue;
      }
      if (encoded.bytes < targetBytes && index > 0) {
        index--;
        continue;
      }
      break;
    }

    return closest;
  }

  Future<({String path, int bytes})?> _runSingleVideoEncode({
    required String sourcePath,
    required _VideoCompressAttempt attempt,
  }) async {
    final mediaInfo = await VideoCompress.compressVideo(
      sourcePath,
      quality: attempt.quality,
      deleteOrigin: false,
      includeAudio: true,
      frameRate: attempt.frameRate,
    );

    final outputPath = mediaInfo?.path;
    if (outputPath == null || outputPath.isEmpty) {
      return null;
    }

    final file = File(outputPath);
    if (!await file.exists()) {
      return null;
    }

    return (path: outputPath, bytes: await file.length());
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

class _VideoEncodeResult {
  const _VideoEncodeResult({
    required this.path,
    required this.bytes,
    required this.attempt,
    required this.attempts,
    required this.distanceToTarget,
  });

  final String path;
  final int bytes;
  final _VideoCompressAttempt attempt;
  final int attempts;
  final double distanceToTarget;
}
