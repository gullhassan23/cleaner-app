import 'dart:io';

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

      final outputDirectory = await _ensureOutputDirectory();
      if (asset.isVideo) {
        return _compressVideo(
          asset,
          sourceFile: sourceFile,
          quality: quality,
          onProgress: onProgress,
        );
      }

      return _compressImage(
        asset,
        sourceFile: sourceFile,
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
        originalBytes: asset.fileSize,
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
      final compressedBytes = await savedFile.length();
      onProgress?.call(1.0);

      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: asset.fileSize,
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
    required CompressionQualityPreset quality,
    void Function(double progress)? onProgress,
  }) async {
    MediaInfo? mediaInfo;
    Subscription? progressSubscription;

    try {
      progressSubscription = VideoCompress.compressProgress$.subscribe((event) {
        onProgress?.call((event / 100).clamp(0.0, 1.0));
      });
      onProgress?.call(0.0);
      mediaInfo = await VideoCompress.compressVideo(
        sourceFile.path,
        quality: _mapVideoQuality(quality),
        deleteOrigin: false,
        includeAudio: true,
      );

      final compressedPath = mediaInfo?.path;
      if (compressedPath == null || compressedPath.isEmpty) {
        return CompressedMediaResultEntity(
          assetId: asset.id,
          mediaType: asset.mediaType,
          originalBytes: asset.fileSize,
          compressedBytes: 0,
          outputPath: '',
          errorMessage: getL10n().compressUnableCompressSelected,
        );
      }

      final compressedFile = File(compressedPath);
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
      final compressedBytes = await savedFile.length();
      onProgress?.call(1.0);

      return CompressedMediaResultEntity(
        assetId: asset.id,
        mediaType: asset.mediaType,
        originalBytes: asset.fileSize,
        compressedBytes: compressedBytes,
        outputPath: savedFile.path,
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
    } finally {
      progressSubscription?.unsubscribe();
      await VideoCompress.deleteAllCache();
    }
  }

  VideoQuality _mapVideoQuality(CompressionQualityPreset quality) {
    switch (quality) {
      case CompressionQualityPreset.low:
        return VideoQuality.LowQuality;
      case CompressionQualityPreset.medium:
        return VideoQuality.MediumQuality;
      case CompressionQualityPreset.high:
        return VideoQuality.DefaultQuality;
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
    final extension = path.extension(safeOriginal).isEmpty
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
    final normalized =
        raw.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
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
