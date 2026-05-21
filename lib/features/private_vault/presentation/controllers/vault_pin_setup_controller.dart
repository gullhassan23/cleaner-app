import 'package:get/get.dart';

import '../../data/datasources/vault_auth_service.dart';
import '../../data/datasources/vault_crypto_service.dart';
import '../../domain/repositories/vault_album_repository.dart';
import '../../domain/repositories/vault_media_repository.dart';
import '../../domain/usecases/vault_auth_usecases.dart';
import '../services/vault_session_service.dart';
import '../../../../routes/app_routes.dart';

class VaultPinSetupController extends GetxController {
  final SetupVaultPin _setup = SetupVaultPin(Get.find<VaultAuthService>());
  final VaultAlbumRepository _albums = Get.find();
  final VaultMediaRepository _media = Get.find();
  final VaultSessionService _session = Get.find();

  final setupStep = 0.obs;
  final buffer = ''.obs;
  final enableBiometric = false.obs;
  final isBusy = false.obs;
  final errorMessage = RxnString();

  String? _firstPin;

  void onDigit(String d) {
    if (isBusy.value || buffer.value.length >= 4) return;
    errorMessage.value = null;
    buffer.value += d;
    if (buffer.value.length == 4) {
      Future<void>.delayed(const Duration(milliseconds: 120), _onComplete);
    }
  }

  void deleteDigit() {
    if (isBusy.value || buffer.value.isEmpty) return;
    buffer.value = buffer.value.substring(0, buffer.value.length - 1);
  }

  Future<void> _onComplete() async {
    final pin = buffer.value;
    buffer.value = '';

    if (setupStep.value == 0) {
      _firstPin = pin;
      setupStep.value = 1;
      return;
    }

    if (pin != _firstPin) {
      errorMessage.value = 'PINs do not match. Try again.';
      setupStep.value = 0;
      _firstPin = null;
      return;
    }

    isBusy.value = true;
    try {
      final canBio = await Get.find<VaultAuthService>().canUseBiometrics();
      final result = await _setup(
        pin: pin,
        enableBiometric: canBio && enableBiometric.value,
      );
      if (!result.isSuccess) {
        errorMessage.value = result.error;
        setupStep.value = 0;
        _firstPin = null;
        return;
      }
      await Get.find<VaultCryptoService>().ensureMasterKey();
      await _albums.ensureDefaultAlbum();
      await _media.purgeScratch();
      _session.unlock();
      await Get.offNamed(
        AppRoutes.privateVaultHome,
        id: AppRoutes.vaultNestedNavigatorId,
      );
    } finally {
      isBusy.value = false;
    }
  }
}
