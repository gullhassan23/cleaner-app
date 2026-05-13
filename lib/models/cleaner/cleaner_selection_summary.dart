class CleanerSelectionSummary {
  const CleanerSelectionSummary({
    required this.selectedCount,
    required this.selectedBytes,
  });

  final int selectedCount;
  final int selectedBytes;

  static const empty = CleanerSelectionSummary(
    selectedCount: 0,
    selectedBytes: 0,
  );
}
