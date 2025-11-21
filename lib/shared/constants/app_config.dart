class AppConfig {
  /// Base URL for your backend API
  /// Example: local LAN server, Ngrok tunnel, or production server
  static const String apiBaseUrl = "http://192.168.101.179:5000";
  //10.1.35.201
//192.168.101.179
//10.246.179.61

  /// App name & metadata (optional)
  static const String appName = "Phone Management System Admin";

  /// Toggle verbose logging across the app
  static const bool debugMode = true;

  /// Timeouts or global limits (if needed)
  static const Duration requestTimeout = Duration(seconds: 15);
}
