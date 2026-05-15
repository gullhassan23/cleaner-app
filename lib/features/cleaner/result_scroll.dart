// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/widgets/cleaner/category_grid.dart';

import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/cleaner_controller.dart';
import 'package:cleaner_app/models/cleaner/cleaner_dashboard_kind.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';

class ResultsScrollBody extends StatelessWidget {
  const ResultsScrollBody({super.key, required this.controller});

  final CleanerController controller;

  static const double _cardGap = 12;
  static const double _columnGap = 12;

  String _sizeLabel(int bytes) {
    if (bytes <= 0) {
      return '0 KB';
    }
    final s = BytesFormatter.humanize(bytes);
    if (s.endsWith('.0 KB')) {
      return '${s.substring(0, s.length - 4)} KB';
    }
    if (s.endsWith('.0 MB')) {
      return '${s.substring(0, s.length - 4)} MB';
    }
    if (s.endsWith('.0 GB')) {
      return '${s.substring(0, s.length - 4)} GB';
    }
    return s;
  }

  double _cardHeight(double columnWidth, double aspectRatio) {
    return columnWidth / aspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final similarBytes = controller.bytesForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupBytes = controller.bytesForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoBytes = controller.bytesForKind(CleanerDashboardKind.videos);
      final shotBytes = controller.bytesForKind(
        CleanerDashboardKind.screenshots,
      );

      final similarPreview = controller.previewForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupPreview = controller.previewForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoPreview = controller.previewForKind(
        CleanerDashboardKind.videos,
      );
      final shotPreview = controller.previewForKind(
        CleanerDashboardKind.screenshots,
      );

      final similarCount = controller.countForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupCount = controller.countForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoCount = controller.countForKind(CleanerDashboardKind.videos);
      final shotCount = controller.countForKind(
        CleanerDashboardKind.screenshots,
      );

      final bottomInset = MediaQuery.paddingOf(context).bottom;

      return LayoutBuilder(
        builder: (context, constraints) {
          final columnWidth = (constraints.maxWidth - _columnGap) / 2;
          // final compactHeight = _cardHeight(columnWidth, 1.05);
          final tallHeight = _cardHeight(columnWidth, 0.88);
          // final mediumHeight = _cardHeight(columnWidth, 0.98);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12 + bottomInset + 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: _cardGap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Similar Photos',
                            sizeLabel: _sizeLabel(similarBytes),
                            preview: similarPreview,
                            placeholderIcon: similarPreview == null,
                            onTap:
                                similarCount == 0
                                    ? null
                                    : controller.openSimilarSheet,
                          ),
                          const SizedBox(height: _cardGap),
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Duplicate Photos',
                            sizeLabel: _sizeLabel(dupBytes),
                            preview: dupPreview,
                            placeholderIcon: dupPreview == null,
                            onTap:
                                dupCount == 0
                                    ? null
                                    : controller.openDuplicateSheet,
                          ),
                          const SizedBox(height: _cardGap),
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Similar Videos',
                            sizeLabel: '0 KB',
                            preview: null,
                            placeholderIcon: true,
                            onTap: null,
                          ),
                          // const SizedBox(height: _cardGap),
                          // CategoryGridCard(
                          //   height: compactHeight,
                          //   title: 'Similar Burst Photos',
                          //   sizeLabel: '0 KB',
                          //   preview: null,
                          //   placeholderIcon: true,
                          //   onTap: null,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _columnGap),
                    Expanded(
                      child: Column(
                        children: [
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Videos',
                            sizeLabel: _sizeLabel(videoBytes),
                            preview: videoPreview,
                            solidBlack: videoPreview == null,
                            inlineVideo: videoPreview != null,
                            placeholderIcon: false,
                            onTap:
                                videoCount == 0
                                    ? null
                                    : controller.openVideosSheet,
                          ),
                          const SizedBox(height: _cardGap),
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Screenshots',
                            sizeLabel: _sizeLabel(shotBytes),
                            preview: shotPreview,
                            placeholderIcon: shotPreview == null,
                            subtitleAboveTitle: 'Optimize Your Storage',
                            topInset: _screenshotsFakeRow(kDashBlue),
                            onTap:
                                shotCount == 0
                                    ? null
                                    : controller.openScreenshotsSheet,
                          ),
                          const SizedBox(height: _cardGap),
                          CategoryGridCard(
                            height: tallHeight,
                            title: 'Similar Live Photos',
                            sizeLabel: _sizeLabel(similarBytes),
                            preview: similarPreview,
                            placeholderIcon: similarPreview == null,
                            onTap:
                                similarCount == 0
                                    ? null
                                    : controller.openSimilarSheet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _cardGap),
                Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    onTap: () => Get.toNamed(AppRoutes.aiPhotoEditor),
                    leading: const Icon(Icons.image, color: Colors.white),
                    title: const Text(
                      'AI Photo Editor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Improve photo quality',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _screenshotsFakeRow(Color kDashBlue) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.contacts_rounded, size: 18, color: kDashBlue),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '3.0 GB',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
