import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../controllers/app_lock_controller.dart';
import '../controllers/app_lock_setup_controller.dart';
import '../controllers/app_lock_verify_controller.dart';
import '../services/app_lock_lifecycle_coordinator.dart';
import '../services/app_lock_service.dart';

class AppLockBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppLockService>()) {
      Get.put(
        AppLockService(
          storage: Get.find<FlutterSecureStorage>(),
          localAuth: Get.find<LocalAuthentication>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<AppLockController>()) {
      Get.put(AppLockController(), permanent: true);
    }
    if (!Get.isRegistered<AppLockLifecycleCoordinator>()) {
      Get.put(AppLockLifecycleCoordinator(), permanent: true);
    }
  }
}

class AppLockSetupBinding extends Bindings {
  @override
  void dependencies() {
    AppLockBinding().dependencies();
    Get.lazyPut(AppLockSetupController.new);
  }
}

class AppLockVerifyBinding extends Bindings {
  @override
  void dependencies() {
    AppLockBinding().dependencies();
    Get.lazyPut(AppLockVerifyController.new);
  }
}
