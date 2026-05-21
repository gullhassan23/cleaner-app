import 'dart:async';

import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../data/datasources/vault_auth_service.dart';
import '../../domain/entities/vault_auth_state.dart';
import '../../domain/usecases/vault_auth_usecases.dart';
import '../services/vault_session_service.dart';
import '../../../../routes/app_routes.dart';

class VaultUnlockController extends GetxController {
  final VerifyVaultPin _verify = VerifyVaultPin(Get.find<VaultAuthService>());
  final VaultAuthService _auth = Get.find();
  final VaultSessionService _session = Get.find();

  final buffer = ''.obs;
  final isBusy = false.obs;
  final errorMessage = RxnString();
  final authState = Rx<VaultAuthState?>(null);
  final lockCountdown = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _refreshState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refreshState());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _refreshState() async {
    authState.value = await _auth.getAuthState();
    lockCountdown.value = authState.value?.lockRemainingSeconds ?? 0;
  }

  void onDigit(String d) {
    final state = authState.value;
    if (isBusy.value || buffer.value.length >= 4) return;
    if (state?.isLockedOut == true) return;
    errorMessage.value = null;
    buffer.value += d;
    if (buffer.value.length == 4) {
      Future<void>.delayed(const Duration(milliseconds: 120), _submitPin);
    }
  }

  void deleteDigit() {
    if (isBusy.value || buffer.value.isEmpty) return;
    buffer.value = buffer.value.substring(0, buffer.value.length - 1);
  }

  Future<void> _submitPin() async {
    final pin = buffer.value;
    buffer.value = '';
    isBusy.value = true;
    try {
      final ok = await _verify(pin);
      if (!ok) {
        await _refreshState();
        errorMessage.value = AppLocalizations.of(Get.context!).vaultIncorrectPin;
        return;
      }
      _session.unlock();
      await Get.offNamed(
        AppRoutes.privateVaultHome,
        id: AppRoutes.vaultNestedNavigatorId,
      );
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> tryBiometric() async {
    if (isBusy.value) return;
    isBusy.value = true;
    try {
      final ok = await _auth.authenticateBiometric();
      if (ok) {
        _session.unlock();
        await Get.offNamed(
        AppRoutes.privateVaultHome,
        id: AppRoutes.vaultNestedNavigatorId,
      );
      }
    } finally {
      isBusy.value = false;
    }
  }
}
