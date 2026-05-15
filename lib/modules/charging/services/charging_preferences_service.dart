import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargingPreferencesService extends GetxService {
  static const String selectedAnimationIdKey = 'selected_animation_id';
  static const String autoShowEnabledKey = 'charging_auto_show_enabled';

  Future<String?> getSelectedAnimationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedAnimationIdKey);
  }

  Future<void> setSelectedAnimationId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedAnimationIdKey, id);
    await prefs.setBool(autoShowEnabledKey, true);
  }

  Future<bool> isAutoShowEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(selectedAnimationIdKey);
    if (id == null || id.isEmpty) {
      return false;
    }
    return prefs.getBool(autoShowEnabledKey) ?? true;
  }

  Future<void> setAutoShowEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoShowEnabledKey, enabled);
  }
}
