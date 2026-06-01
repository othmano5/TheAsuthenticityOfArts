import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Response<Map<String, dynamic>>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response<Map<String, dynamic>>> postJson(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<Map<String, dynamic>>> postFormData(
    String path, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<Map<String, dynamic>>(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: Options(
        headers: const {'Content-Type': 'multipart/form-data'},
      ),
    );
  }
}
