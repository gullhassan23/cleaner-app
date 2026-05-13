import '../../models/compress/compress_entities.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';

class CompressSessionState {
  const CompressSessionState({
    required this.permissionState,
    required this.mediaItems,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
    required this.isLoadingInitial,
    required this.isLoadingMore,
    required this.selectedAssetIds,
    required this.quality,
    required this.progress,
    required this.results,
    required this.isCompressing,
    this.errorMessage,
    this.successMessage,
  });

  final PermissionStateEntity permissionState;
  final List<PhotoAssetEntity> mediaItems;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final Set<String> selectedAssetIds;
  final CompressionQualityPreset quality;
  final CompressionProgressEntity progress;
  final List<CompressedMediaResultEntity> results;
  final bool isCompressing;
  final String? errorMessage;
  final String? successMessage;

  bool get hasSelection => selectedAssetIds.isNotEmpty;
  bool get canLoadMore => hasMore && !isLoadingInitial && !isLoadingMore;
  bool get canAccessMedia => permissionState.canAccess;

  CompressSessionState copyWith({
    PermissionStateEntity? permissionState,
    List<PhotoAssetEntity>? mediaItems,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    Set<String>? selectedAssetIds,
    CompressionQualityPreset? quality,
    CompressionProgressEntity? progress,
    List<CompressedMediaResultEntity>? results,
    bool? isCompressing,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return CompressSessionState(
      permissionState: permissionState ?? this.permissionState,
      mediaItems: _freezeList(mediaItems, this.mediaItems),
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedAssetIds: _freezeSet(selectedAssetIds, this.selectedAssetIds),
      quality: quality ?? this.quality,
      progress: progress ?? this.progress,
      results: _freezeList(results, this.results),
      isCompressing: isCompressing ?? this.isCompressing,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  factory CompressSessionState.initial() {
    return const CompressSessionState(
      permissionState: PermissionStateEntity(
        status: MediaPermissionStatus.initial,
      ),
      mediaItems: <PhotoAssetEntity>[],
      page: 0,
      pageSize: 60,
      totalCount: 0,
      hasMore: false,
      isLoadingInitial: false,
      isLoadingMore: false,
      selectedAssetIds: <String>{},
      quality: CompressionQualityPreset.medium,
      progress: CompressionProgressEntity(
        phase: CompressionPhase.idle,
        processedCount: 0,
        totalCount: 0,
        label: 'Ready to compress',
      ),
      results: <CompressedMediaResultEntity>[],
      isCompressing: false,
    );
  }
}

List<T> _freezeList<T>(List<T>? next, List<T> current) {
  if (next == null || identical(next, current)) {
    return current;
  }
  return List<T>.unmodifiable(next);
}

Set<T> _freezeSet<T>(Set<T>? next, Set<T> current) {
  if (next == null || identical(next, current)) {
    return current;
  }
  return Set<T>.unmodifiable(next);
}
