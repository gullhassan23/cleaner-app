import 'dart:typed_data';

class ThumbnailCacheService {
  ThumbnailCacheService({
    this.maxEntries = 300,
    this.maxBytes = 64 * 1024 * 1024,
  });

  final int maxEntries;
  final int maxBytes;

  final Map<String, Uint8List> _memoryCache = <String, Uint8List>{};
  final Map<String, Future<Uint8List?>> _inFlight =
      <String, Future<Uint8List?>>{};
  int _currentBytes = 0;

  Future<Uint8List?> getOrLoad(
    String key,
    Future<Uint8List?> Function() loader,
  ) {
    final cached = _memoryCache[key];
    if (cached != null) {
      _touchKey(key, cached);
      return Future<Uint8List?>.value(cached);
    }

    final inflight = _inFlight[key];
    if (inflight != null) {
      return inflight;
    }

    final future = loader().then((result) {
      if (result != null) {
        _cacheValue(key, result);
      }
      _inFlight.remove(key);
      return result;
    });

    _inFlight[key] = future;
    return future;
  }

  void invalidate(String key) {
    final removed = _memoryCache.remove(key);
    if (removed != null) {
      _currentBytes -= removed.lengthInBytes;
    }
    _inFlight.remove(key);
  }

  void clearWhere(bool Function(String key, Uint8List value) shouldRemove) {
    final keys = <String>[];
    for (final entry in _memoryCache.entries) {
      if (shouldRemove(entry.key, entry.value)) {
        keys.add(entry.key);
      }
    }
    for (final key in keys) {
      invalidate(key);
    }
  }

  void clear() {
    _memoryCache.clear();
    _inFlight.clear();
    _currentBytes = 0;
  }

  void _cacheValue(String key, Uint8List value) {
    if (value.lengthInBytes > maxBytes) {
      invalidate(key);
      return;
    }

    final existing = _memoryCache.remove(key);
    if (existing != null) {
      _currentBytes -= existing.lengthInBytes;
    }

    _memoryCache[key] = value;
    _currentBytes += value.lengthInBytes;
    _evictIfNeeded();
  }

  void _touchKey(String key, Uint8List value) {
    _memoryCache.remove(key);
    _memoryCache[key] = value;
  }

  void _evictIfNeeded() {
    while (_memoryCache.length > maxEntries || _currentBytes > maxBytes) {
      final oldestKey = _memoryCache.keys.first;
      final removed = _memoryCache.remove(oldestKey);
      if (removed != null) {
        _currentBytes -= removed.lengthInBytes;
      }
    }
  }
}
