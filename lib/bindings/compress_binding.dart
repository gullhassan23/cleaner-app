import 'package:get/get.dart';

import '../services/photo_library/photo_library_use_cases.dart';
import '../services/compression/media_compression_service.dart';
import '../controllers/compress/compress_picker_controller.dart';
import '../controllers/compress/compress_review_controller.dart';
import '../controllers/compress/compress_session_controller.dart';

class CompressBinding extends Bindings {
  @override
  void dependencies() {
    _lazyPutIfAbsent(() => GetMediaPermissionStateUseCase(Get.find()));
    _lazyPutIfAbsent(() => RequestMediaPermissionUseCase(Get.find()));
    _lazyPutIfAbsent(() => FetchMediaGalleryPageUseCase(Get.find()));
    _lazyPutIfAbsent(() => OpenPhotoSettingsUseCase(Get.find()));
    _lazyPutIfAbsent(() => PresentLimitedMediaPickerUseCase(Get.find()));
    _lazyPutIfAbsent(() => LoadOriginalFileUseCase(Get.find()));

    if (!Get.isRegistered<MediaCompressionService>()) {
      Get.put(
        MediaCompressionService(loadOriginalFileUseCase: Get.find()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<CompressSessionController>()) {
      Get.put(
        CompressSessionController(
          getMediaPermissionStateUseCase: Get.find(),
          requestMediaPermissionUseCase: Get.find(),
          fetchMediaGalleryPageUseCase: Get.find(),
          openPhotoSettingsUseCase: Get.find(),
          presentLimitedMediaPickerUseCase: Get.find(),
          mediaCompressionService: Get.find(),
        ),
        permanent: true,
      );
    }

    _lazyPutIfAbsent(() => CompressPickerController(Get.find()), fenix: true);
    _lazyPutIfAbsent(() => CompressReviewController(Get.find()), fenix: true);
  }

  void _lazyPutIfAbsent<T>(
    InstanceBuilderCallback<T> builder, {
    bool fenix = true,
  }) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(builder, fenix: fenix);
    }
  }
}
