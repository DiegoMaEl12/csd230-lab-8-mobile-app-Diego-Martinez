import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // 10.0.2.2 is the special IP to reach your PC's localhost from Android Emulator
    baseUrl: 'http://10.0.2.2:8080/api/rest',
  ));

  final _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          // Handle session expired / logout logic here
        }
        return handler.next(e);
      },
    ));
  }

  Dio get client => _dio;
}