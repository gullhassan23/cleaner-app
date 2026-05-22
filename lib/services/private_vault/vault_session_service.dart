import 'package:get/get.dart';

/// In-memory vault unlock session (not persisted).
class VaultSessionService extends GetxService {
  final isUnlocked = false.obs;

  void unlock() => isUnlocked.value = true;

  void lock() => isUnlocked.value = false;
}
