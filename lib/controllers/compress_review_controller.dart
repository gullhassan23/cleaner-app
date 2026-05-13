import 'dart:async';

import 'package:get/get.dart';

import '../models/compress/compress_entities.dart';
import 'main_shell_controller.dart';
import '../routes/app_routes.dart';
import 'compress_session_controller.dart';

class CompressReviewController extends GetxController {
  CompressReviewController(this.session);

  final CompressSessionController session;

  @override
  void onReady() {
    super.onReady();
    if (!session.hasSelection) {
      unawaited(_navigateToMainCompressTab());
    }
  }

  Future<void> _navigateToMainCompressTab() async {
    await Get.offNamed<void>(AppRoutes.main);
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToCompress();
    }
  }

  void updateQuality(CompressionQualityPreset preset) {
    session.updateQuality(preset);
  }

  Future<void> compressSelected() {
    return session.compressSelectedAssets();
  }

  void clearMessages() {
    session.clearMessages();
  }
}
