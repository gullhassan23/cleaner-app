import 'package:get/get.dart';

import '../controllers/charging_controller.dart';
import '../platform/charging_nav_coordinator.dart';
import '../services/charging_catalog_service.dart';
import '../services/charging_preferences_service.dart';
import '../services/charging_service.dart';

class ChargingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChargingService>()) {
      Get.lazyPut<ChargingService>(ChargingService.new, fenix: true);
    }
    if (!Get.isRegistered<ChargingCatalogService>()) {
      Get.lazyPut<ChargingCatalogService>(ChargingCatalogService.new, fenix: true);
    }
    if (!Get.isRegistered<ChargingPreferencesService>()) {
      Get.lazyPut<ChargingPreferencesService>(
        ChargingPreferencesService.new,
        fenix: true,
      );
    }
    Get.lazyPut<ChargingController>(
      () => ChargingController(
        batteryService: Get.find<ChargingService>(),
        catalogService: Get.find<ChargingCatalogService>(),
        preferencesService: Get.find<ChargingPreferencesService>(),
        navCoordinator: Get.find<ChargingNavCoordinator>(),
      ),
      fenix: true,
    );
  }
}
