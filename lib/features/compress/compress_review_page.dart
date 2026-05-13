import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/bytes_formatter.dart';
import '../../widgets/state_message_card.dart';
import '../../models/compress/compress_entities.dart';
import '../../models/photo_library/photo_asset_entity.dart';
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
                  message: 'Go back and select at least one image or video.',
                ),
              ],
            );
          }

          final previewAsset = selectedAssets.first;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              _PreviewCard(asset: previewAsset, repository: repository),
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
              _SizeSummaryCard(
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
                          (preset) => _QualityCard(
                            preset: preset,
                            isSelected: session.quality == preset,
                            onTap: () => controller.updateQuality(preset),
                          ),
                        )
                        .toList(growable: false),
              ),
              const SizedBox(height: 20),
              if (session.isCompressing || session.progress.phase != CompressionPhase.idle)
                _CompressionProgressCard(progress: session.progress),
              if (session.successMessage != null) ...[
                const SizedBox(height: 16),
                _StatusMessageCard(
                  color: const Color(0xFF127A45),
                  icon: Icons.check_circle_outline_rounded,
                  message: session.successMessage!,
                ),
              ],
              if (session.errorMessage != null) ...[
                const SizedBox(height: 16),
                _StatusMessageCard(
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
                  child: _ResultCard(
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

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.asset, required this.repository});

  final PhotoAssetEntity asset;
  final PhotoLibraryRepository repository;

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        asset.aspectRatio.isFinite && asset.aspectRatio > 0
            ? asset.aspectRatio
            : 1.0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: FutureBuilder<Uint8List?>(
                    future: repository.loadPreviewBytes(
                      asset.id,
                      width: 1400,
                      height: 1400,
                      quality: 90,
                    ),
                    builder: (context, snapshot) {
                      final bytes = snapshot.data;
                      if (bytes == null) {
                        return Center(
                          child:
                              snapshot.connectionState == ConnectionState.waiting
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.broken_image_outlined),
                        );
                      }
                      return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
                    },
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.04),
                        Colors.black.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                ),
                if (asset.isVideo)
                  const Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0x99000000),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                      ),
                    ),
                  ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          asset.title ?? (asset.isVideo ? 'Selected video' : 'Selected image'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (asset.isVideo)
                        _DarkPill(label: _formatDuration(asset.duration))
                      else
                        _DarkPill(label: '${asset.width} x ${asset.height}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _SizeSummaryCard extends StatelessWidget {
  const _SizeSummaryCard({
    required this.originalBytes,
    required this.estimatedBytes,
    required this.savedBytes,
  });

  final int originalBytes;
  final int estimatedBytes;
  final int savedBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SizeMetric(
                    label: 'Original',
                    value: BytesFormatter.humanize(originalBytes),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SizeMetric(
                    label: 'Compressed',
                    value: BytesFormatter.humanize(estimatedBytes),
                    valueColor: const Color(0xFFD14A4A),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Estimated savings: ${BytesFormatter.humanize(savedBytes)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeMetric extends StatelessWidget {
  const _SizeMetric({
    required this.label,
    required this.value,
    this.valueColor,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge, textAlign: textAlign),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}

class _QualityCard extends StatelessWidget {
  const _QualityCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final CompressionQualityPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          color:
              isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.08)
                  : theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              preset.label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : null,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Compress ${preset.savingsPercent}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompressionProgressCard extends StatelessWidget {
  const _CompressionProgressCard({required this.progress});

  final CompressionProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Compression progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${progress.overallPercent}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              progress.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value:
                  progress.phase == CompressionPhase.running ||
                          progress.phase == CompressionPhase.completed
                      ? progress.progress
                      : 0,
              minHeight: 9,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            if (progress.currentFileLabel != null) ...[
              Text(
                'Current file: ${progress.currentFileLabel}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value:
                    progress.phase == CompressionPhase.running ||
                            progress.phase == CompressionPhase.completed
                        ? progress.currentFileProgress.clamp(0.0, 1.0)
                        : 0,
                minHeight: 7,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 6),
              Text(
                'Current file progress: ${progress.currentFilePercent}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '${progress.processedCount} of ${progress.totalCount} done • ${progress.remainingCount} remaining',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusMessageCard extends StatelessWidget {
  const _StatusMessageCard({
    required this.color,
    required this.icon,
    required this.message,
  });

  final Color color;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.asset, required this.result});

  final PhotoAssetEntity? asset;
  final CompressedMediaResultEntity result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asset?.title ?? 'Compressed file',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _DarkPill(
                  label: 'From ${BytesFormatter.humanize(result.originalBytes)}',
                  dark: false,
                ),
                _DarkPill(
                  label: 'To ${BytesFormatter.humanize(result.compressedBytes)}',
                  dark: false,
                ),
                _DarkPill(
                  label: 'Saved ${BytesFormatter.humanize(result.savedBytes)}',
                  dark: false,
                ),
              ],
            ),
            if (result.errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                result.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DarkPill extends StatelessWidget {
  const _DarkPill({required this.label, this.dark = true});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color =
        dark
            ? Colors.black.withValues(alpha: 0.45)
            : Theme.of(context).colorScheme.surfaceContainerHigh;
    final textColor = dark ? Colors.white : Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
