import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyEmail = 'saved_email';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyUserData = 'user_data';

  static Future<void> saveSession(String email, bool rememberMe, String? userDataJson) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString(_keyEmail, email);
      await prefs.setBool(_keyRememberMe, true);
      if (userDataJson != null) {
        await prefs.setString(_keyUserData, userDataJson);
      }
    } else {
      await prefs.remove(_keyEmail);
      await prefs.setBool(_keyRememberMe, false);
      await prefs.remove(_keyUserData);
    }
  }

  static Future<Map<String, dynamic>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyEmail) ?? '',
      'rememberMe': prefs.getBool(_keyRememberMe) ?? false,
      'userData': prefs.getString(_keyUserData),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.setBool(_keyRememberMe, false);
    await prefs.remove(_keyUserData);
  }
}
