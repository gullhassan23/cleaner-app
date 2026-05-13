enum MediaPermissionStatus {
  initial,
  loading,
  granted,
  denied,
  permanentlyDenied,
  limited,
}

class PermissionStateEntity {
  const PermissionStateEntity({
    required this.status,
    this.canOpenSystemPicker = false,
  });

  final MediaPermissionStatus status;
  final bool canOpenSystemPicker;

  bool get canAccess =>
      status == MediaPermissionStatus.granted ||
      status == MediaPermissionStatus.limited;

  bool get needsSettings => status == MediaPermissionStatus.permanentlyDenied;

  bool get isLimited => status == MediaPermissionStatus.limited;
}

class DeletionResultEntity {
  const DeletionResultEntity({
    required this.deletedCount,
    required this.failedIds,
    required this.reclaimedBytes,
  });

  final int deletedCount;
  final List<String> failedIds;
  final int reclaimedBytes;

  bool get hasPartialFailure => failedIds.isNotEmpty;
}
