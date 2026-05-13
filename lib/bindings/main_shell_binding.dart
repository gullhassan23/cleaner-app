import 'package:get/get.dart';

import '../controllers/main_shell_controller.dart';
import 'cleaner_binding.dart';
import 'compress_binding.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    CleanerBinding().dependencies();
    CompressBinding().dependencies();
    Get.put(MainShellController());
  }
}
