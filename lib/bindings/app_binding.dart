import 'package:get/get.dart';

import '../services/photo_library/photo_library_data_source.dart';
import '../services/photo_library/photo_library_repository_impl.dart';
import '../repositories/photo_library_repository.dart';
import '../services/cache/thumbnail_cache_service.dart';
import '../services/deletion/photo_delete_service.dart';
import '../services/gallery/gallery_media_service.dart';
import '../services/permissions/photo_permission_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhotoPermissionService(), permanent: true);
    Get.put(GalleryMediaService(), permanent: true);
    Get.put(ThumbnailCacheService(), permanent: true);
    Get.put(PhotoDeleteService(), permanent: true);

    Get.put(
      PhotoLibraryDataSource(
        permissionService: Get.find(),
        galleryService: Get.find(),
        deleteService: Get.find(),
        thumbnailCacheService: Get.find(),
      ),
      permanent: true,
    );

    Get.put<PhotoLibraryRepository>(
      PhotoLibraryRepositoryImpl(dataSource: Get.find()),
      permanent: true,
    );
  }
}
