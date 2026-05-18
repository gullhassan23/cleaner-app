enum PhotoWidgetSourceMode {
  activeAlbum('active_album'),
  allAlbums('all_albums');

  const PhotoWidgetSourceMode(this.storageValue);

  final String storageValue;

  static PhotoWidgetSourceMode fromStorage(String? value) {
    return PhotoWidgetSourceMode.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => PhotoWidgetSourceMode.activeAlbum,
    );
  }
}
