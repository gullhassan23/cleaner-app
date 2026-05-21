import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/photo_widget/photo_widget_controller.dart';
import '../../models/photo_widget/photo_widget_style.dart';
import '../../widgets/photo_widget/photo_widget_scaffold.dart';

class PhotoWidgetStyleView extends GetView<PhotoWidgetController> {
  const PhotoWidgetStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: PhotoWidgetAppBar(title: l10n.photoWidgetWidgetStyle),
      body: Obx(() {
        final style = controller.style;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<PhotoWidgetStyle>(
              segments: [
                ButtonSegment(
                  value: PhotoWidgetStyle.grid,
                  label: Text(l10n.photoWidgetGrid),
                  icon: const Icon(Icons.grid_view, size: 18),
                ),
                ButtonSegment(
                  value: PhotoWidgetStyle.slideshow,
                  label: Text(l10n.photoWidgetSlideshow),
                  icon: const Icon(Icons.slideshow, size: 18),
                ),
              ],
              selected: {style},
              onSelectionChanged: (next) {
                if (next.isEmpty) return;
                controller.setStyle(next.first);
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.photoWidgetPreview,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: style == PhotoWidgetStyle.grid
                    ? _GridPreview()
                    : _SlideshowPreview(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              style == PhotoWidgetStyle.grid
                  ? l10n.photoWidgetGridDescription
                  : l10n.photoWidgetSlideshowDescription,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        );
      }),
    );
  }
}

class _GridPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        4,
        (_) => ColoredBox(
          color: scheme.surfaceContainerHigh,
          child: Icon(Icons.image, color: scheme.primary),
        ),
      ),
    );
  }
}

class _SlideshowPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
