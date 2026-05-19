import 'package:get/get.dart';

import '../controllers/photo_widget/photo_widget_controller.dart';
import '../widgets/photo_widget/photo_widget_repository.dart';
import '../widgets/photo_widget/photo_widget_storage_service.dart';

class PhotoWidgetBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PhotoWidgetStorageService>()) {
      Get.put(PhotoWidgetStorageService(), permanent: true);
    }
    if (!Get.isRegistered<PhotoWidgetRepository>()) {
      Get.put(PhotoWidgetRepository(), permanent: true);
    }
    if (!Get.isRegistered<PhotoWidgetController>()) {
      Get.put(PhotoWidgetController(), permanent: true);
    }
  }
}

class PhotoWidgetRouteBinding extends Bindings {
  @override
  void dependencies() {
    PhotoWidgetBinding().dependencies();
  }
}
