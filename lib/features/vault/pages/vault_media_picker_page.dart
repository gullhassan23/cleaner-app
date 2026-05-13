import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../services/gallery/gallery_media_service.dart';

/// Multi-select recent photos and videos (newest first).
class VaultMediaPickerPage extends StatefulWidget {
  const VaultMediaPickerPage({super.key});

  @override
  State<VaultMediaPickerPage> createState() => _VaultMediaPickerPageState();
}

class _VaultMediaPickerPageState extends State<VaultMediaPickerPage> {
  final _gallery = Get.find<GalleryMediaService>();
  final _assets = <AssetEntity>[];
  final _selected = <String>{};
  final _scroll = ScrollController();
  int _page = 0;
  static const _pageSize = 80;
  bool _loading = false;
  bool _end = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    unawaited(_loadNext());
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_end || _loading) return;
    final pos = _scroll.position;
    if (pos.pixels > pos.maxScrollExtent - 400) {
      unawaited(_loadNext());
    }
  }

  Future<void> _loadNext() async {
    setState(() => _loading = true);
    try {
      final batch = await _gallery.getPagedMediaAssets(
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      if (batch.isEmpty) {
        _end = true;
      } else {
        _assets.addAll(batch);
        _page++;
        if (batch.length < _pageSize) _end = true;
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggle(AssetEntity a) {
    setState(() {
      if (_selected.contains(a.id)) {
        _selected.remove(a.id);
      } else {
        _selected.add(a.id);
      }
    });
  }

  void _confirm() {
    final out = <AssetEntity>[];
    for (final a in _assets) {
      if (_selected.contains(a.id)) out.add(a);
    }
    Get.back(result: out);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F1A),
        foregroundColor: Colors.white,
        title: const Text('Import to vault'),
        actions: [
          TextButton(
            onPressed: _selected.isEmpty ? null : _confirm,
            child: Text(
              'Import (${_selected.length})',
              style: const TextStyle(
                color: Color(0xFF5B8DEF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Tap items to select. Only selected items are imported.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _assets.length + (_loading && !_end ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= _assets.length) {
                  return const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final a = _assets[i];
                final sel = _selected.contains(a.id);
                return GestureDetector(
                  onTap: () => _toggle(a),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _VaultPickerThumb(asset: a),
                      if (a.type == AssetType.video)
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color:
                                sel
                                    ? const Color(0xFF5B8DEF)
                                    : Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              sel ? Icons.check_rounded : Icons.circle_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultPickerThumb extends StatelessWidget {
  const _VaultPickerThumb({required this.asset});

  final AssetEntity asset;

  static const _size = ThumbnailSize.square(200);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(_size),
      builder: (context, snap) {
        if (snap.hasData && snap.data != null) {
          return Image.memory(snap.data!, fit: BoxFit.cover, gaplessPlayback: true);
        }
        return Container(color: const Color(0xFF1A2235));
      },
    );
  }
}
