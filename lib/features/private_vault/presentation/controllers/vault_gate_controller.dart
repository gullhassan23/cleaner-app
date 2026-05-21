import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../data/datasources/vault_auth_service.dart';
import '../../domain/repositories/vault_album_repository.dart';
import '../services/vault_session_service.dart';
import '../../../../routes/app_routes.dart';

class VaultGateController extends GetxController {
  final VaultAuthService _auth = Get.find();
  final VaultSessionService _session = Get.find();
  final VaultAlbumRepository _albums = Get.find();

  final isLoading = true.obs;
  final routeFailed = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Nested Navigator mounts one frame after this controller; routing too
    // early leaves the gate page stuck on the loader.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      unawaited(_route());
    });
  }

  void retry() => unawaited(_route());

  Future<void> _route() async {
    isLoading.value = true;
    routeFailed.value = false;
    try {
      final enabled = await _auth.isEnabled();
      final target = !enabled
          ? AppRoutes.privateVaultSetup
          : _session.isUnlocked.value
              ? AppRoutes.privateVaultHome
              : AppRoutes.privateVaultUnlock;

      if (target == AppRoutes.privateVaultHome) {
        await _albums.ensureDefaultAlbum();
      }

      final ok = await _replaceNestedRoute(target);
      if (!ok) routeFailed.value = true;
    } catch (_) {
      routeFailed.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _replaceNestedRoute(String route) async {
    for (var attempt = 0; attempt < 10; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(Duration(milliseconds: 32 * attempt));
      }
      final state =
          Get.nestedKey(AppRoutes.vaultNestedNavigatorId)?.currentState;
      if (state != null) {
        await state.pushReplacementNamed(route);
        return true;
      }
    }
    final result = await Get.offNamed(
      route,
      id: AppRoutes.vaultNestedNavigatorId,
      preventDuplicates: false,
    );
    return result != null;
  }
}
