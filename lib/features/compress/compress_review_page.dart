


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

import '../../repositories/photo_library_repository.dart';
import '../../controllers/compress_review_controller.dart';

class CompressReviewPage extends GetView<CompressReviewController> {
  const CompressReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<PhotoLibraryRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Compress')),
      bottomNavigationBar: Obx(() {
        final session = controller.session.state.value;
        final canCompress = session.hasSelection && !session.isCompressing;

        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FilledButton(
            onPressed: canCompress ? controller.compressSelected : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child:
                session.isCompressing
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            '${session.progress.overallPercent}% • ${session.progress.remainingCount} left',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                    : const Text('COMPRESS'),
          ),
        );
      }),
      body: SafeArea(
        child: Obx(() {
          final session = controller.session.state.value;
          final selectedAssets = controller.session.selectedAssets;
          if (selectedAssets.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                StateMessageCard(
                  icon: Icons.photo_library_outlined,
                  title: 'No media selected',
                  message: 'Go back and select at least one video.',
                ),
              ],
            );
          }

          final previewAsset = selectedAssets.first;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              PreviewCard(asset: previewAsset, repository: repository),
              if (selectedAssets.length > 1) ...[
                const SizedBox(height: 10),
                Center(
                  child: Chip(
                    avatar: const Icon(Icons.collections_outlined, size: 18),
                    label: Text('${selectedAssets.length} items selected'),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SizeSummaryCard(
                originalBytes: controller.session.selectedOriginalBytes,
                estimatedBytes: controller.session.estimatedCompressedBytes,
                savedBytes: controller.session.estimatedSavedBytes,
              ),
              const SizedBox(height: 20),
              Text('Quality', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    CompressionQualityPreset.values
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
              if (session.isCompressing || session.progress.phase != CompressionPhase.idle)
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
                Text('Compression results', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...session.results.map((result) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ResultCard(
                    asset: selectedAssets.firstWhereOrNull(
                      (asset) => asset.id == result.assetId,
                    ),
                    result: result,
                  ),
                )),
              ],
            ],
          );
        }),
      ),
    );
  }
}
















