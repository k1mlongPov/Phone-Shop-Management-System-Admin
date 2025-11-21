import 'package:dio/dio.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/auth/domain/models/user_model.dart';

class AuthRepository {
  final ApiService api;
  final LocalStorageService storage;

  AuthRepository({required this.api, required this.storage});

  // Extract token safely
  String? _extractToken(dynamic body) {
    if (body is Map) {
      return body['token'] ??
          body['accessToken'] ??
          body['userToken'] ??
          (body['data'] is Map ? body['data']['token'] : null);
    }
    return null;
  }

  // Extract user safely
  Map<String, dynamic>? _extractUser(dynamic body) {
    if (body is Map) {
      if (body['user'] is Map) return Map<String, dynamic>.from(body['user']);
      if (body['data'] is Map && body['data']['user'] is Map) {
        return Map<String, dynamic>.from(body['data']['user']);
      }
      if (body['username'] != null || body['email'] != null) {
        return Map<String, dynamic>.from(body);
      }
    }
    return null;
  }

  // Persist token only — ApiService will attach header automatically
  Future<void> _saveToken(String token) async {
    await storage.setAuthToken(token);
  }

  // Remove token
  Future<void> _clearToken() async {
    await storage.clearAuthToken();
  }

  // ---------------- REGISTER ----------------
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final res = await api.post(
        '/api/auth/register',
        {
          'username': username.trim(),
          'email': email.trim(),
          'password': password,
        },
      );

      if (res.statusCode != 201) {
        throw Exception(res.data['message'] ?? "Register failed");
      }

      final user = _extractUser(res.data);
      return user ?? {};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Register failed");
    }
  }

  // ---------------- LOGIN ----------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await api.post(
        '/api/auth/login',
        {'email': email.trim(), 'password': password},
      );

      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? "Login failed");
      }

      final body = res.data;
      final token = _extractToken(body);
      final userMap = _extractUser(body);

      if (token == null || userMap == null) {
        throw Exception("Invalid login response");
      }

      // Must be admin (backend already enforces it, we double-check)
      final roles =
          (userMap['roles'] as List?)?.map((e) => e.toString()).toList() ?? [];
      if (!roles.map((e) => e.toLowerCase()).contains("admin")) {
        throw Exception(
            "You do not have permission to access the admin panel.");
      }

      await _saveToken(token);

      return {
        'user': UserModel.fromJson(userMap),
        'token': token,
      };
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Login failed");
    }
  }

  // ---------------- GET CURRENT USER ----------------
  Future<UserModel> getCurrentUser() async {
    try {
      final res = await api.get('/api/auth/me');
      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? 'Failed to fetch user');
      }

      final userMap = _extractUser(res.data);
      if (userMap == null) throw Exception("Invalid user data");

      return UserModel.fromJson(userMap);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to fetch user");
    }
  }

  // ---------------- VERIFY PUBLIC ----------------
  Future<UserModel> verifyPublic({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await api.post('/api/auth/verify', {
        'email': email.trim(),
        'otp': otp.trim(),
      });

      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? "Verify failed");
      }

      final userJson = res.data['user'];
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Verify failed");
    }
  }

  // ---------------- RESEND OTP ----------------
  Future<void> requestResendOtp({required String email}) async {
    try {
      final res = await api.post(
        '/api/auth/resend-otp',
        {'email': email.trim()},
      );

      if (res.statusCode! < 200 || res.statusCode! >= 300) {
        throw Exception(res.data['message'] ?? "OTP resend failed");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "OTP resend failed");
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _clearToken();
  }
}
