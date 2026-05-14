// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cleaner_app/widgets/cleaner/category_grid.dart';
import 'package:cleaner_app/widgets/storage_strip.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/cleaner_controller.dart';
import 'package:cleaner_app/models/cleaner/cleaner_dashboard_kind.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';

class ResultsScrollBody extends StatelessWidget {
  const ResultsScrollBody({super.key, required this.controller});

  final CleanerController controller;

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final gap = 10.0;
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

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StorageStrip(),
            SizedBox(height: gap + 56),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CategoryGridCard(
                        height: 118,
                        title: 'Similar Photos',
                        sizeLabel: _sizeLabel(similarBytes),
                        preview: similarPreview,
                        placeholderIcon: similarPreview == null,
                        onTap:
                            similarCount == 0
                                ? null
                                : controller.openSimilarSheet,
                      ),
                      SizedBox(height: gap),
                      CategoryGridCard(
                        height: 118,
                        title: 'Duplicate Photos',
                        sizeLabel: _sizeLabel(dupBytes),
                        preview: dupPreview,
                        placeholderIcon: dupPreview == null,
                        onTap:
                            dupCount == 0
                                ? null
                                : controller.openDuplicateSheet,
                      ),
                      SizedBox(height: gap),
                      CategoryGridCard(
                        height: 118,
                        title: 'Similar Videos',
                        sizeLabel: '0 KB',
                        preview: null,
                        placeholderIcon: true,
                        onTap: null,
                      ),
                      SizedBox(height: gap),
                      CategoryGridCard(
                        height: 118,
                        title: 'Similar Burst Photos',
                        sizeLabel: '0 KB',
                        preview: null,
                        placeholderIcon: true,
                        onTap: null,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: Column(
                    children: [
                      CategoryGridCard(
                        height: 200,
                        title: 'Videos',
                        sizeLabel: _sizeLabel(videoBytes),
                        preview: videoPreview,
                        solidBlack: videoPreview == null,
                        inlineVideo: videoPreview != null,
                        placeholderIcon: false,
                        onTap:
                            videoCount == 0 ? null : controller.openVideosSheet,
                      ),
                      SizedBox(height: gap),
                      CategoryGridCard(
                        height: 168,
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
                      SizedBox(height: gap),
                      CategoryGridCard(
                        height: 118,
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
          ],
        ),
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
