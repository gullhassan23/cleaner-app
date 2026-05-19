enum PhotoWidgetStyle {
  grid('grid'),
  slideshow('slideshow');

  const PhotoWidgetStyle(this.storageValue);

  final String storageValue;

  static PhotoWidgetStyle fromStorage(String? value) {
    return PhotoWidgetStyle.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => PhotoWidgetStyle.grid,
    );
  }
}
