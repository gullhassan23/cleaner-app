class VaultAlbum {
  const VaultAlbum({
    required this.id,
    required this.name,
    this.coverMediaId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? coverMediaId;
  final DateTime createdAt;
}
