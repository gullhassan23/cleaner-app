import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/models/private_vault/vault_media.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository.dart';

class VaultMediaTile extends StatefulWidget {
  const VaultMediaTile({
    super.key,
    required this.media,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onToggleSelect,
  });

  final VaultMedia media;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onToggleSelect;

  @override
  State<VaultMediaTile> createState() => _VaultMediaTileState();
}

class _VaultMediaTileState extends State<VaultMediaTile> {
  String? _thumbPath;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    try {
      final path = await Get.find<VaultMediaRepository>()
          .decryptThumbnailToMemoryPath(widget.media);
      if (mounted) setState(() => _thumbPath = path);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.selectionMode ? widget.onToggleSelect : widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_thumbPath != null)
              Image.file(File(_thumbPath!), fit: BoxFit.cover)
            else
              ColoredBox(color: cs.surfaceContainerHighest),
            if (widget.media.isVideo)
              const Positioned(
                left: 6,
                bottom: 6,
                child: Icon(
                  Icons.videocam_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            if (widget.selectionMode)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: widget.selected
                        ? cs.primary
                        : Colors.black26,
                  ),
                  child: widget.selected
                      ? Icon(Icons.check, size: 14, color: cs.onPrimary)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
