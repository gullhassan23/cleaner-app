import 'dart:async';

import 'package:cleaner_app/utils/colors.dart';
import 'package:disk_usage/disk_usage.dart';
import 'package:flutter/material.dart';

class StorageStrip extends StatefulWidget {
  const StorageStrip({super.key});

  @override
  State<StorageStrip> createState() => _StorageStripState();
}

class _StorageStripState extends State<StorageStrip> {
  int? _total;
  int? _free;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final total = await DiskUsage.totalSpace();
    final free = await DiskUsage.freeSpace();
    if (!mounted) {
      return;
    }
    setState(() {
      _total = total;
      _free = free;
    });
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
    final total = _total;
    final free = _free;
    int? used;
    double? progressValue;
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
            style: const TextStyle(
              fontSize: 15,
              color: kDashGrey,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: 'Used: '),
              TextSpan(
                text: used != null ? _gb(used) : '—',
                style: const TextStyle(
                  color: kDashBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: total != null ? ' / ${_gb(total)}' : '',
                style: const TextStyle(color: kDashGrey),
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
            backgroundColor: const Color(0xFFE9E9EE),
            color: kDashBlue,
          ),
        ),
      ],
    );
  }
}
