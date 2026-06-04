import '../photo_library/photo_asset_entity.dart';

enum CompressionQualityPreset { low, medium, high }

extension CompressionQualityPresetX on CompressionQualityPreset {
  String get label {
    switch (this) {
      case CompressionQualityPreset.low:
        return 'Low';
      case CompressionQualityPreset.medium:
        return 'Medium';
      case CompressionQualityPreset.high:
        return 'High';
    }
  }

  int get imageQuality {
    switch (this) {
      case CompressionQualityPreset.low:
        return 35;
      case CompressionQualityPreset.medium:
        return 60;
      case CompressionQualityPreset.high:
        return 82;
    }
  }

  /// Fraction of original file size expected after compression.
  /// High quality keeps more (0.8), Low quality keeps less (0.2).
  double get estimatedOutputRatio {
    switch (this) {
      case CompressionQualityPreset.low:
        return 0.20;
      case CompressionQualityPreset.medium:
        return 0.50;
      case CompressionQualityPreset.high:
        return 0.80;
    }
  }

  /// How much smaller the file should get (20 / 50 / 80).
  int get compressionPercent => ((1 - estimatedOutputRatio) * 100).round();

  /// Target output size as a fraction of the original (0.8 = keep 80%).
  int get targetKeepPercent => (estimatedOutputRatio * 100).round();

  int targetBytesFor(int originalBytes) =>
      (originalBytes * estimatedOutputRatio).round().clamp(1, originalBytes);
}

enum CompressionPhase { idle, running, completed, failed }

class CompressionProgressEntity {
  const CompressionProgressEntity({
    required this.phase,
    required this.processedCount,
    required this.totalCount,
    required this.label,
    this.currentFileProgress = 0,
    this.currentFileLabel,
  });

  final CompressionPhase phase;
  final int processedCount;
  final int totalCount;
  final String label;
  final double currentFileProgress;
  final String? currentFileLabel;

  double get progress {
    if (totalCount <= 0) {
      return 0;
    }
    final normalizedCurrent = currentFileProgress.clamp(0.0, 1.0);
    return ((processedCount + normalizedCurrent) / totalCount).clamp(0.0, 1.0);
  }

  int get overallPercent => (progress * 100).round();

  int get currentFilePercent =>
      (currentFileProgress.clamp(0.0, 1.0) * 100).round();

  int get remainingCount {
    final activeItemOffset =
        phase == CompressionPhase.running && totalCount > processedCount
            ? 1
            : 0;
    final remaining = totalCount - processedCount - activeItemOffset;
    return remaining < 0 ? 0 : remaining;
  }
}

class CompressedMediaResultEntity {
  const CompressedMediaResultEntity({
    required this.assetId,
    required this.mediaType,
    required this.originalBytes,
    required this.compressedBytes,
    required this.outputPath,
    this.errorMessage,
  });

  final String assetId;
  final GalleryMediaType mediaType;
  final int originalBytes;
  final int compressedBytes;
  final String outputPath;
  final String? errorMessage;

  int get savedBytes =>
      originalBytes > compressedBytes ? originalBytes - compressedBytes : 0;

  bool get isSuccess => errorMessage == null && outputPath.isNotEmpty;
}
