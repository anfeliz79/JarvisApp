import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class AppConfigStorage {
  static const _baseUrlKey = 'jarvis.baseUrl';
  static const _tokenKey = 'jarvis.token';
  static const _previewModeKey = 'jarvis.previewMode';

  Future<AppConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppConfig(
      baseUrl: prefs.getString(_baseUrlKey) ?? '',
      token: prefs.getString(_tokenKey) ?? '',
      previewMode: prefs.getBool(_previewModeKey) ?? true,
    );
  }

  Future<void> save(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, config.baseUrl.trim());
    await prefs.setString(_tokenKey, config.token.trim());
    await prefs.setBool(_previewModeKey, config.previewMode);
  }
}
