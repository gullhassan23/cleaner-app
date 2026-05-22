class VaultImportSummary {
  const VaultImportSummary({
    required this.importedCount,
    required this.failedItems,
    required this.galleryDeleteFailedIds,
  });

  final int importedCount;
  final List<String> failedItems;
  final List<String> galleryDeleteFailedIds;
}
