import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // cache
  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  // Call in main()
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedAccessToken = prefs.getString(_keyAccessToken);
    _cachedRefreshToken = prefs.getString(_keyRefreshToken);
  }

  // =====================
  // ACCESS TOKEN
  // =====================

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
    _cachedAccessToken = token;
  }

  String? getAuthToken() => _cachedAccessToken;

  Future<String?> getAuthTokenAsync() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedAccessToken = prefs.getString(_keyAccessToken);
    return _cachedAccessToken;
  }

  // =====================
  // REFRESH TOKEN
  // =====================

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRefreshToken, token);
    _cachedRefreshToken = token;
  }

  String? getRefreshToken() => _cachedRefreshToken;

  Future<String?> getRefreshTokenAsync() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedRefreshToken = prefs.getString(_keyRefreshToken);
    return _cachedRefreshToken;
  }

  // =====================
  // CLEAR ALL TOKENS
  // =====================

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }
}
