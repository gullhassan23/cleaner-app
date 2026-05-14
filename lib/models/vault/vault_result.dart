class VaultResult<T> {
  const VaultResult._({this.data, this.errorMessage});

  const VaultResult.success(this.data) : errorMessage = null;

  factory VaultResult.failure(String message) =>
      VaultResult._(errorMessage: message);

  final T? data;
  final String? errorMessage;

  bool get isSuccess => errorMessage == null;
}
