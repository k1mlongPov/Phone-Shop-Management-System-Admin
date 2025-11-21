import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyAuthToken = 'auth_token';
  static String? _cachedToken;

  // Call this once on app start (in main) to initialize the cache
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_keyAuthToken);
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
    _cachedToken = token;
  }

  // Synchronous getter (reads cached value)
  String? getAuthToken() => _cachedToken;

  Future<String?> getAuthTokenAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_keyAuthToken);
    _cachedToken = t;
    return t;
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
    _cachedToken = null;
  }
}
