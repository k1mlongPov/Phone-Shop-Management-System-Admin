import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:get/get.dart';

class ApiService {
  late final Dio dioClient;
  final String baseUrl;
  final LocalStorageService storage;

  ApiService({required this.baseUrl, required this.storage}) {
    dioClient = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': '*/*',
        },
      ),
    );

    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = storage.getAuthToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (err, handler) async {
          print(
              '*** API ERR <-- ${err.response?.statusCode} ${err.requestOptions.uri}');

          // ====== CHECK FOR TOKEN EXPIRED ======
          if (err.response?.statusCode == 401) {
            final refreshed = await _refreshAccessToken();

            if (refreshed) {
              // Retry request with new token
              final newAccessToken = storage.getAuthToken();

              final cloneRequest = await dioClient.request(
                err.requestOptions.path,
                data: err.requestOptions.data,
                queryParameters: err.requestOptions.queryParameters,
                options: Options(
                  method: err.requestOptions.method,
                  headers: {
                    ...err.requestOptions.headers,
                    'Authorization': 'Bearer $newAccessToken',
                  },
                ),
              );

              return handler.resolve(cloneRequest);
            } else {
              // Refresh failed → logout
              await storage.clearAll();
              Get.offAllNamed(Routes.LOGIN);
            }
          }

          return handler.next(err);
        },
      ),
    );
  }

  // ===== REFRESH TOKEN LOGIC =====
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await dioClient.post(
        "/api/auth/refresh",
        data: {"refreshToken": refreshToken},
      );

      final newAccessToken = response.data["accessToken"];
      if (newAccessToken == null) return false;

      await storage.saveAuthToken(newAccessToken);
      return true;
    } catch (e) {
      print("Refresh failed: $e");
      return false;
    }
  }

  Future<dio.Response<dynamic>> get(String path,
          {Map<String, dynamic>? query}) =>
      dioClient.get(path, queryParameters: query);

  Future<dio.Response<dynamic>> post(String path, dynamic data,
          {Map<String, dynamic>? query}) =>
      dioClient.post(path, data: data, queryParameters: query);

  Future<dio.Response<dynamic>> put(String path, dynamic data) =>
      dioClient.put(path, data: data);

  Future<dio.Response<dynamic>> delete(String path) => dioClient.delete(path);
}
