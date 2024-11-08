import 'package:dio/dio.dart';
import 'package:dio_learning_1/core/config/api_config.dart';

class DioInterceptors extends Interceptor {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    "Access-Control-Allow-Origin": "*",
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  DioInterceptors({required this.isSecure}) : _cancelToken = CancelToken();
  bool isSecure;
  final CancelToken _cancelToken;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Cancel any ongoing request
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel("Cancelled due to a new request");
    }

    // Create a new CancelToken for the new request
    options.cancelToken = CancelToken();

    if (isSecure) {
      headers['Authorization'] = ApiConfig.apiKey;
    } else {
      headers.removeWhere(
        (key, value) => key == 'Authorization',
      );
    }
    options.headers.addAll(headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors globally
    super.onError(err, handler);
  }
}
