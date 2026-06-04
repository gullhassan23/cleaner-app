import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/widgets/compress/compression_progress_card.dart';
import 'package:cleaner_app/widgets/compress/preview_card.dart';
import 'package:cleaner_app/widgets/compress/quality_card.dart';
import 'package:cleaner_app/widgets/compress/result_card.dart';
import 'package:cleaner_app/widgets/compress/size_summary.dart';
import 'package:cleaner_app/widgets/compress/status_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/state_message_card.dart';
import '../../models/compress/compress_entities.dart';

import '../../services/repositories/photo_library/photo_library_repository.dart';
import '../../controllers/compress/compress_review_controller.dart';

class CompressReviewPage extends GetView<CompressReviewController> {
  const CompressReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<PhotoLibraryRepository>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(l10n.compressTitle)),
      bottomNavigationBar: Obx(() {
        final session = controller.session.state.value;
        final canCompress = session.hasSelection && !session.isCompressing;
        final hasCompletedResults =
            session.results.isNotEmpty &&
            session.progress.phase == CompressionPhase.completed;

        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child:
              session.isCompressing
                  ? OutlinedButton.icon(
                    onPressed: controller.cancelCompression,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded),
                    label: Text(l10n.commonCancel),
                  )
                  : hasCompletedResults
                  ? FilledButton(
                    onPressed: controller.finishAndReturn,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(l10n.commonDone),
                  )
                  : FilledButton(
                    onPressed: canCompress ? controller.compressSelected : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(l10n.compressButton),
                  ),
        );
      }),
      body: SafeArea(
        child: Obx(() {
          final session = controller.session.state.value;
          final selectedAssets = controller.session.selectedAssets;
          final hasCompletedResults =
              session.results.isNotEmpty &&
              session.progress.phase == CompressionPhase.completed;
          if (selectedAssets.isEmpty && !hasCompletedResults) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                StateMessageCard(
                  icon: Icons.photo_library_outlined,
                  title: l10n.compressNoMediaSelected,
                  message: l10n.compressNoMediaSelectedBody,
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              if (selectedAssets.isNotEmpty) ...[
                CompressPreviewPager(
                  assets: selectedAssets,
                  repository: repository,
                ),
                if (selectedAssets.length > 1) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: Chip(
                      avatar: const Icon(Icons.collections_outlined, size: 18),
                      label: Text(
                        l10n.compressItemsSelected(selectedAssets.length),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
              ],
              SizeSummaryCard(
                key: ValueKey(
                  '${session.quality}_${session.results.length}_${session.progress.phase}',
                ),
                originalBytes:
                    controller.session.hasActualCompressionResults
                        ? controller.session.actualOriginalBytes
                        : controller.session.selectedOriginalBytes,
                estimatedBytes:
                    controller.session.hasActualCompressionResults
                        ? controller.session.actualCompressedBytes
                        : controller.session.estimatedCompressedBytes,
                savedBytes:
                    controller.session.hasActualCompressionResults
                        ? controller.session.actualSavedBytes
                        : controller.session.estimatedSavedBytes,
                showActualResults:
                    controller.session.hasActualCompressionResults,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.compressQuality,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: CompressionQualityPreset.values
                    .map(
                      (preset) => QualityCard(
                        preset: preset,
                        isSelected: session.quality == preset,
                        onTap: () => controller.updateQuality(preset),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 20),
              if (session.isCompressing ||
                  session.progress.phase != CompressionPhase.idle)
                CompressionProgressCard(progress: session.progress),
              if (session.successMessage != null) ...[
                const SizedBox(height: 16),
                StatusMessageCard(
                  color: const Color(0xFF127A45),
                  icon: Icons.check_circle_outline_rounded,
                  message: session.successMessage!,
                ),
              ],
              if (session.errorMessage != null) ...[
                const SizedBox(height: 16),
                StatusMessageCard(
                  color: Theme.of(context).colorScheme.error,
                  icon: Icons.error_outline_rounded,
                  message: session.errorMessage!,
                ),
              ],
              if (session.results.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.compressCompressionResults,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...session.results.map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ResultCard(
                      asset: selectedAssets.firstWhereOrNull(
                        (asset) => asset.id == result.assetId,
                      ),
                      result: result,
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
