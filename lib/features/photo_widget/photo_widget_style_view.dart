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

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: const PhotoWidgetAppBar(title: 'Widget style'),
      body: Obx(() {
        final style = controller.style;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<PhotoWidgetStyle>(
              segments: const [
                ButtonSegment(
                  value: PhotoWidgetStyle.grid,
                  label: Text('Grid'),
                  icon: Icon(Icons.grid_view, size: 18),
                ),
                ButtonSegment(
                  value: PhotoWidgetStyle.slideshow,
                  label: Text('Slideshow'),
                  icon: Icon(Icons.slideshow, size: 18),
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
              'Preview',
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
                  ? 'Shows a 2×2 grid of your photos on the home screen widget.'
                  : 'Rotates through photos on a timer (minimum 15 seconds).',
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
