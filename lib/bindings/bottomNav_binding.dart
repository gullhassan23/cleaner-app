



import 'package:cleaner_app/controllers/bottomnav_controller.dart';
import 'package:get/get.dart';

import 'cleaner_binding.dart';
import 'compress_binding.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    CleanerBinding().dependencies();
    CompressBinding().dependencies();
    Get.put(BottomNavController());
  }
}
