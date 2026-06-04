abstract final class BytesFormatter {
  static String humanize(int bytes) {
    if (bytes <= 0) {
      return '0 B';
    }

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const unitStep = 1000.0;
    var value = bytes.toDouble();
    var index = 0;

    // Use decimal units to align with system gallery size labels.
    while (value >= unitStep && index < units.length - 1) {
      value /= unitStep;
      index++;
    }

    final formatted =
        value >= 10 || index == 0
            ? value.toStringAsFixed(0)
            : value.toStringAsFixed(1);
    return '$formatted ${units[index]}';
  }
}
