import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../routes/app_routes.dart';
import '../../../repositories/vault_repository.dart';
import '../models/vault_media_model.dart';

/// Passed via [Get.toNamed] `arguments` for [AppRoutes.vaultMediaPreview].
class VaultMediaPreviewArgs {
  const VaultMediaPreviewArgs({required this.model, required this.file});

  final VaultMediaModel model;
  final File file;
}

class VaultMediaPreviewPage extends StatefulWidget {
  const VaultMediaPreviewPage({
    super.key,
    required this.model,
    required this.file,
  });

  final VaultMediaModel model;
  final File file;

  @override
  State<VaultMediaPreviewPage> createState() => _VaultMediaPreviewPageState();
}

class _VaultMediaPreviewPageState extends State<VaultMediaPreviewPage> {
  VideoPlayerController? _video;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.model.isVideo) {
      _video = VideoPlayerController.file(widget.file);
      _video!
          .initialize()
          .then((_) {
            if (!mounted) return;
            setState(() => _videoReady = true);
            _video!.play();
          })
          .catchError((Object e) {
            if (mounted) {
              Get.snackbar('Vault', 'Could not open video: $e');
            }
          });
    }
  }

  @override
  void dispose() {
    _video?.dispose();
    super.dispose();
  }

  VaultRepository get _repo => Get.find<VaultRepository>();

  Future<void> _restore() async {
    final r = await _repo.restoreToGallery(widget.model);
    if (!mounted) return;
    if (r.isSuccess) {
      Get.snackbar('Vault', 'Saved copy to your photo library.');
    } else {
      Get.snackbar('Vault', r.errorMessage ?? 'Restore failed');
    }
  }

  Future<void> _delete() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete from vault?'),
        content: const Text(
          'This removes the file from private storage. '
          'If you restored to Photos, that copy stays in your library.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    final r = await _repo.deleteFromVault([widget.model.id]);
    if (!mounted) return;
    if (r.isSuccess) {
      Get.back<void>();
    } else {
      Get.snackbar('Vault', r.errorMessage ?? 'Delete failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.model.isVideo ? 'Video' : 'Photo',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: widget.model.isVideo
                  ? _videoReady && _video != null
                      ? Builder(
                          builder: (context) {
                            final ar = _video!.value.aspectRatio;
                            final ratio =
                                (!ar.isFinite || ar <= 0) ? 16 / 9 : ar;
                            return AspectRatio(
                              aspectRatio: ratio,
                              child: VideoPlayer(_video!),
                            );
                          },
                        )
                      : const CircularProgressIndicator(color: Color(0xFF5B8DEF))
                  : InteractiveViewer(
                      minScale: 0.6,
                      maxScale: 4,
                      child: Image.file(widget.file, fit: BoxFit.contain),
                    ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _restore,
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('Save to Photos'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
