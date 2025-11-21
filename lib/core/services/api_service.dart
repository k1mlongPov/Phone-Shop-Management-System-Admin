import 'package:dio/dio.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';

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
          'Content-Type': 'application/json',
        },
      ),
    );

    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final cached = storage.getAuthToken();
            if (cached != null && cached.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $cached';
            } else {
              final asyncToken = await storage.getAuthTokenAsync();
              if (asyncToken != null && asyncToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $asyncToken';
              }
            }
          } catch (e) {
            print('ApiService: failed to attach token: $e');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (err, handler) {
          print(
              '*** API ERR <-- ${err.response?.statusCode} ${err.requestOptions.uri}');
          return handler.next(err);
        },
      ),
    );
  }

  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      dioClient.get(path, queryParameters: query);

  Future<Response<dynamic>> post(String path, dynamic data,
          {Map<String, dynamic>? query}) =>
      dioClient.post(path, data: data, queryParameters: query);

  Future<Response<dynamic>> put(String path, dynamic data) =>
      dioClient.put(path, data: data);

  Future<Response<dynamic>> delete(String path) => dioClient.delete(path);
}
