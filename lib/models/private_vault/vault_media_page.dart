import 'vault_media.dart';

class VaultMediaPage {
  const VaultMediaPage({
    required this.items,
    required this.totalCount,
    required this.hasMore,
  });

  final List<VaultMedia> items;
  final int totalCount;
  final bool hasMore;
}
