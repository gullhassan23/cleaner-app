/// Result type for app lock service operations.
class AppLockResult<T> {
  const AppLockResult._({this.value, this.errorMessage});

  const AppLockResult.success(T? value) : this._(value: value);

  const AppLockResult.failure(String message) : this._(errorMessage: message);

  final T? value;
  final String? errorMessage;

  bool get isSuccess => errorMessage == null;
}
