import 'dart:async';

import 'package:cleaner_app/controllers/bottomnav_controller.dart';
import 'package:get/get.dart';

import '../../models/compress/compress_entities.dart';

import '../../routes/app_routes.dart';
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
    if (Get.nestedKey(AppRoutes.compressNestedNavigatorId)?.currentState !=
        null) {
      await Get.offNamed<void>(
        AppRoutes.compressMain,
        id: AppRoutes.compressNestedNavigatorId,
      );
      return;
    }
    await Get.offNamed<void>(AppRoutes.main);
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().goToCompress();
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
