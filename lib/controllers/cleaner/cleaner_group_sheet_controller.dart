import 'package:cleaner_app/l10n/l10n_get.dart';
import 'package:get/get.dart';

import '../../models/cleaner/cleaner_media_cluster.dart';
import '../../models/cleaner/cleaner_sheet_mode.dart';
import '../../models/cleaner/cleaner_selection_summary.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../services/repositories/photo_library/photo_library_repository.dart';
import '../../utils/bytes_formatter.dart';

class CleanerGroupSheetController extends GetxController {
  CleanerGroupSheetController({
    required this.mode,
    required List<CleanerMediaCluster> clusters,
    required void Function(Set<String> ids) onDeleted,
  }) : _clusters = clusters,
       _onDeleted = onDeleted;

  final CleanerSheetMode mode;
  final List<CleanerMediaCluster> _clusters;
  final void Function(Set<String> ids) _onDeleted;

  final PhotoLibraryRepository _repository = Get.find<PhotoLibraryRepository>();

  List<CleanerMediaCluster> get clusters => _clusters;

  final RxMap<String, bool> selectedForDelete = <String, bool>{}.obs;

  final Rx<CleanerSelectionSummary> selectionSummaryRx =
      CleanerSelectionSummary.empty.obs;

  final RxBool isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    for (final cluster in _clusters) {
      for (final m in cluster.members) {
        selectedForDelete[m.id] = m.id != cluster.keeper.id;
      }
    }
    _refreshSummary();
  }

  void _refreshSummary() {
    var count = 0;
    var bytes = 0;
    for (final cluster in _clusters) {
      for (final m in cluster.members) {
        if (selectedForDelete[m.id] == true) {
          count++;
          bytes += m.fileSize;
        }
      }
    }
    selectionSummaryRx.value = CleanerSelectionSummary(
      selectedCount: count,
      selectedBytes: bytes,
    );
  }

  void toggleSelection(String assetId) {
    final current = selectedForDelete[assetId] ?? false;
    selectedForDelete[assetId] = !current;
    selectedForDelete.refresh();
    _refreshSummary();
  }

  bool isSelected(String assetId) => selectedForDelete[assetId] ?? false;

  Future<void> deleteSelected() async {
    final ids = selectedForDelete.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toSet();
    if (ids.isEmpty) {
      return;
    }

    final assets = <PhotoAssetEntity>[];
    for (final cluster in _clusters) {
      for (final m in cluster.members) {
        if (ids.contains(m.id)) {
          assets.add(m);
        }
      }
    }

    isDeleting.value = true;
    try {
      final result = await _repository.deleteAssets(assets);
      final requestedIds = assets.map((a) => a.id).toSet();
      final confirmed = requestedIds.difference(result.failedIds.toSet());

      if (result.deletedCount > 0) {
        _onDeleted(confirmed);
        Get.back<void>();
        final l10n = getL10n();
        Get.snackbar(
          l10n.cleanerDeletedTitle,
          l10n.cleanerDeletedMessage(
            result.deletedCount,
            BytesFormatter.humanize(result.reclaimedBytes),
          ),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        if (result.hasPartialFailure) {
          Get.snackbar(
            l10n.cleanerSomeItemsNotRemoved,
            l10n.cleanerSomeItemsFailed(result.failedIds.length),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        final l10n = getL10n();
        Get.snackbar(
          l10n.cleanerNothingDeleted,
          l10n.cleanerNothingDeletedHint,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isDeleting.value = false;
    }
  }
}
