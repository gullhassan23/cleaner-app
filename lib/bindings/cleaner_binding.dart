import 'package:get/get.dart';

import '../controllers/cleaner/cleaner_controller.dart';
import '../services/repositories/photo_library_repository.dart';
import '../services/cleaner/duplicate_detector_service.dart';
import '../services/cleaner/gallery_scan_coordinator.dart';
import '../services/cleaner/similar_detector_service.dart';

class CleanerBinding extends Bindings {
  @override
  void dependencies() {
    final repository = Get.find<PhotoLibraryRepository>();

    Get.lazyPut(
      () => GalleryScanCoordinator(repository: repository),
      fenix: true,
    );
    Get.lazyPut(
      () => DuplicateDetectorService(repository: repository),
      fenix: true,
    );
    Get.lazyPut(
      () => SimilarDetectorService(repository: repository),
      fenix: true,
    );

    Get.put<CleanerController>(
      CleanerController(
        repository: repository,
        scanCoordinator: Get.find<GalleryScanCoordinator>(),
        duplicateDetector: Get.find<DuplicateDetectorService>(),
        similarDetector: Get.find<SimilarDetectorService>(),
      ),
    );
  }
}
