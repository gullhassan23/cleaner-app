import 'dart:io';

import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:photo_manager/photo_manager.dart';

import '../../models/photo_library/scan_state_entity.dart';

class PhotoPermissionService {
  Future<PermissionStateEntity> getPermissionState() async {
    return getPhotoPermissionState();
  }

  Future<PermissionStateEntity> requestPermission() async {
    return requestPhotoPermission();
  }

  Future<void> openAppSettings() async {
    await permission_handler.openAppSettings();
  }

  Future<void> presentLimitedPicker() async {
    await presentLimitedPhotoPicker();
  }

  Future<PermissionStateEntity> getPhotoPermissionState() {
    return _getPermissionState(type: RequestType.image);
  }

  Future<PermissionStateEntity> requestPhotoPermission() {
    return _requestPermission(type: RequestType.image);
  }

  Future<void> presentLimitedPhotoPicker() {
    return PhotoManager.presentLimited(type: RequestType.image);
  }

  Future<PermissionStateEntity> getMediaPermissionState() {
    return _getPermissionState(type: RequestType.common);
  }

  Future<PermissionStateEntity> requestMediaPermission() {
    return _requestPermission(type: RequestType.common);
  }

  Future<void> presentLimitedMediaPicker() {
    return PhotoManager.presentLimited(type: RequestType.common);
  }

  PermissionStateEntity _mapPermissionState(
    PermissionState permissionState, {
    required bool permanentlyDenied,
  }) {
    if (permissionState == PermissionState.limited) {
      return const PermissionStateEntity(
        status: MediaPermissionStatus.limited,
        canOpenSystemPicker: true,
      );
    }

    if (permissionState.isAuth) {
      return const PermissionStateEntity(status: MediaPermissionStatus.granted);
    }

    if (permissionState == PermissionState.restricted || permanentlyDenied) {
      return const PermissionStateEntity(
        status: MediaPermissionStatus.permanentlyDenied,
      );
    }

    return const PermissionStateEntity(status: MediaPermissionStatus.denied);
  }

  Future<bool> _isPermanentlyDenied() async {
    final statuses = <permission_handler.PermissionStatus>[];

    if (Platform.isIOS || Platform.isAndroid) {
      statuses.add(await permission_handler.Permission.photos.status);
    }

    if (Platform.isAndroid) {
      statuses.add(await permission_handler.Permission.storage.status);
    }

    return statuses.any(
      (status) => status.isPermanentlyDenied || status.isRestricted,
    );
  }

  Future<PermissionStateEntity> _getPermissionState({
    required RequestType type,
  }) async {
    final permissionState = await PhotoManager.getPermissionState(
      requestOption: _permissionRequestOption(type),
    );
    final permanentlyDenied = await _isPermanentlyDenied();
    return _mapPermissionState(
      permissionState,
      permanentlyDenied: permanentlyDenied,
    );
  }

  Future<PermissionStateEntity> _requestPermission({
    required RequestType type,
  }) async {
    final permissionState = await PhotoManager.requestPermissionExtend(
      requestOption: _permissionRequestOption(type),
    );
    final permanentlyDenied =
        !permissionState.hasAccess && await _isPermanentlyDenied();
    return _mapPermissionState(
      permissionState,
      permanentlyDenied: permanentlyDenied,
    );
  }

  PermissionRequestOption _permissionRequestOption(RequestType type) {
    return PermissionRequestOption(
      iosAccessLevel: IosAccessLevel.readWrite,
      androidPermission: AndroidPermission(type: type, mediaLocation: false),
    );
  }
}
