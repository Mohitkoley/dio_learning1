import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dio_isolate_pro/dio_isolate_pro.dart';
import 'package:dio_learning_1/core/exception/custom_exception.dart';
import 'package:dio_learning_1/core/network/dio_client.dart';
import 'package:dio_learning_1/core/network/dio_custom_cache_interceptor.dart';
import 'package:dio_learning_1/core/network/dio_interceptor.dart';
import 'package:dio_learning_1/core/network/dio_logging_interceptor.dart';
import 'package:dio_learning_1/core/network/dio_retry_interceptor.dart';

class ApiClient {
  final DioClient _dioClient;

  final List<Interceptor> _defaultInterceptors = [
    LoggingInterceptor(),
    RetryInterceptor(),
  ];

  ApiClient()
      : _dioClient = DioClient(
          dio: Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: timeout),
            ),
          )..httpClientAdapter = Http2Adapter(
              ConnectionManager(idleTimeout: const Duration(seconds: timeout))),
        ) {
    _dioClient.dio
      ..interceptors.addAll(_defaultInterceptors)
      ..transformer = DioIsolatePro();
  }

  static const int timeout = 60;

  dynamic decodedRes;

  setRes(Response<dynamic> res) {
    decodedRes = jsonDecode(res.data);
    return decodedRes;
  }

  void addOrRemoveInterCeptor(bool isSecure, {bool isCache = false}) {
    _dioClient.dio.interceptors.removeWhere(
      (element) => element is DioInterceptors,
    );

    // TODO: don't know why this is not working
    _dioClient.dio.interceptors.add(DioInterceptors(isSecure: isSecure));

    if (isCache) {
      _dioClient.dio.interceptors.add(DioCustomCacheInterceptor());
    } else {
      _dioClient.dio.interceptors.removeWhere(
        (element) => element is DioCustomCacheInterceptor,
      );
    }
  }

  // GET request (with and without API key)
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool isSecure = true,
    bool isCache = false,
  }) async {
    addOrRemoveInterCeptor(isSecure, isCache: isCache);
    try {
      return await _dioClient.get(endpoint, queryParams: queryParams);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  // POST request (with and without API key)
  Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParameters, bool isSecure = true}) async {
    addOrRemoveInterCeptor(
      isSecure,
    );
    addOrRemoveInterCeptor(isSecure);
    try {
      return await _dioClient.post(endpoint, body,
          queryParameters: queryParameters);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  // PUT request (with and without API key)
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParameters,
    bool isSecure = true,
  }) async {
    addOrRemoveInterCeptor(isSecure);
    try {
      return await _dioClient.put(endpoint, body,
          queryParameters: queryParameters);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  // PATCH request (with and without API key)
  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParameters,
    bool isSecure = true,
  }) async {
    addOrRemoveInterCeptor(isSecure);
    try {
      return await _dioClient.patch(endpoint, body,
          queryParameters: queryParameters);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  // DELETE request (with and without API key)
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    addOrRemoveInterCeptor(true);
    try {
      return await _dioClient.delete(endpoint, queryParams: queryParams);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  Future<dynamic> uploadFile(String filePath, String fileName,
      {required String urlPath,
      String keyName = "file",
      Map<String, dynamic>? body,
      UploadType type = UploadType.post}) async {
    addOrRemoveInterCeptor(true);
    try {
      return await _dioClient.uploadFile(filePath, fileName, body,
          urlPath: urlPath, keyName: keyName, type: type);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }

  Future<dynamic> downloadFile(String url, {String? savePath}) async {
    addOrRemoveInterCeptor(true);
    try {
      return await _dioClient.downloadFile(url, savePath: savePath);
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }
  }
}
