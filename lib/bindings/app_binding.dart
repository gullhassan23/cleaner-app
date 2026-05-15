import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../modules/charging/platform/charging_nav_coordinator.dart';
import '../modules/charging/services/charging_catalog_service.dart';
import '../modules/charging/services/charging_preferences_service.dart';
import '../modules/charging/services/charging_service.dart';
import '../services/vault/vault_lifecycle_coordinator.dart';
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
    Get.put(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
      permanent: true,
    );
    Get.put(LocalAuthentication(), permanent: true);
    Get.put(VaultLifecycleCoordinator(), permanent: true);

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

    Get.put(ChargingService(), permanent: true);
    Get.put(ChargingCatalogService(), permanent: true);
    Get.put(ChargingPreferencesService(), permanent: true);
    Get.put(
      ChargingNavCoordinator(
        Get.find<ChargingPreferencesService>(),
        Get.find<ChargingService>(),
      ),
      permanent: true,
    );
  }
}
