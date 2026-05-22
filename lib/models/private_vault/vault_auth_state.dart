class VaultAuthState {
  const VaultAuthState({
    required this.isEnabled,
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
    required this.isLockedOut,
    this.lockRemainingSeconds = 0,
  });

  final bool isEnabled;
  final bool isBiometricEnabled;
  final bool canUseBiometrics;
  final bool isLockedOut;
  final int lockRemainingSeconds;
}
