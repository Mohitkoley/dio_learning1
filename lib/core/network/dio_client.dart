import 'package:dio/dio.dart';

enum UploadType { put, post, patch }

class DioClient {
  final Dio _dio;

  Dio get dio => _dio;

  // PathHelper pathHelper = PathHelper();

  DioClient({required Dio dio}) : _dio = dio;

  // GET request (with and without API key)
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(endpoint,
        data: body, queryParameters: queryParameters);
  }

  Future<Response> patch(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.patch(endpoint, data: body);
  }

  // PUT request (with and without API key)
  Future<Response> put(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(endpoint, data: body);
  }

  // DELETE request (with and without API key)
  Future<Response> delete(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await _dio.delete(endpoint, queryParameters: queryParams);
  }

  Future<Response> uploadFile(
      String filePath, String fileName, Map<String, dynamic>? body,
      {required String urlPath,
      required String keyName,
      required UploadType type}) async {
    Map<String, dynamic> map = {
      keyName: await MultipartFile.fromFile(filePath, filename: fileName),
    };
    if (body != null) {
      map.addAll(body);
    }
    FormData formData = FormData.fromMap(map);

    switch (type) {
      case UploadType.put:
        return await _dio.put(urlPath, data: formData);
      case UploadType.post:
        return await _dio.post(urlPath, data: formData);
      case UploadType.patch:
        return await _dio.patch(urlPath, data: formData);
    }
  }

  Future<Response> downloadFile(String url, {String? savePath}) async {
    return await _dio.download(url, savePath);
  }
}
