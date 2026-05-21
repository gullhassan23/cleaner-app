import '../../data/datasources/vault_auth_service.dart';
import '../entities/vault_auth_state.dart';

class GetVaultAuthState {
  GetVaultAuthState(this._auth);
  final VaultAuthService _auth;
  Future<VaultAuthState> call() => _auth.getAuthState();
}

class SetupVaultPin {
  SetupVaultPin(this._auth);
  final VaultAuthService _auth;
  Future<VaultAuthResult<void>> call({
    required String pin,
    required bool enableBiometric,
  }) =>
      _auth.setupPin(pin: pin, enableBiometric: enableBiometric);
}

class VerifyVaultPin {
  VerifyVaultPin(this._auth);
  final VaultAuthService _auth;
  Future<bool> call(String pin) => _auth.verifyPin(pin);
}

class ChangeVaultPin {
  ChangeVaultPin(this._auth);
  final VaultAuthService _auth;
  Future<VaultAuthResult<void>> call({
    required String oldPin,
    required String newPin,
  }) =>
      _auth.changePin(oldPin: oldPin, newPin: newPin);
}
