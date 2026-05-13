abstract final class BytesFormatter {
  static String humanize(int bytes) {
    if (bytes <= 0) {
      return '0 B';
    }

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var index = 0;

    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }

    final formatted =
        value >= 10 || index == 0
            ? value.toStringAsFixed(0)
            : value.toStringAsFixed(1);
    return '$formatted ${units[index]}';
  }
}
