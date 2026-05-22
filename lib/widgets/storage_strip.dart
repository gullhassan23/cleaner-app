import 'dart:async';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:disk_usage/disk_usage.dart';
import 'package:flutter/material.dart';

class StorageStrip extends StatefulWidget {
  const StorageStrip({super.key});

  @override
  State<StorageStrip> createState() => _StorageStripState();
}

class _StorageStripState extends State<StorageStrip> {
  late final Future<({int? total, int? free})> _future = _loadSpace();

  static Future<({int? total, int? free})> _loadSpace() async {
    final total = await DiskUsage.totalSpace();
    final free = await DiskUsage.freeSpace();
    return (total: total, free: free);
  }

  String _gb(int bytes) {
    final g = bytes / (1024 * 1024 * 1024);
    if (g >= 10) {
      return '${g.toStringAsFixed(0)} GB';
    }
    return '${g.toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<({int? total, int? free})>(
      future: _future,
      builder: (context, snap) {
        final data = snap.data;
        int? used;
        double? progressValue;
        final total = data?.total;
        final free = data?.free;
        if (total != null && free != null && total > 0) {
          used = (total - free).clamp(0, total);
          final r = used / total;
          if (r <= 0) {
            progressValue = 0;
          } else if (r < 0.02) {
            progressValue = 0.02;
          } else {
            progressValue = r;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: cs.dashMuted,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: l10n.cleanerStorageUsed,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: used != null ? _gb(used) : '—',
                    style: TextStyle(
                      fontSize: 17,
                      color: cs.dashPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: total != null ? ' / ${_gb(total)}' : '',
                    style: TextStyle(
                      color: cs.dashMuted,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 10,
                backgroundColor: cs.progressTrack,
                color: cs.dashPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}
