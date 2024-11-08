import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries = 3;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.unknown) {
      // Retry logic
      final requestOptions = err.response?.requestOptions;
      if (requestOptions != null) {
        for (var i = 0; i < maxRetries; i++) {
          Dio().fetch(requestOptions).then((response) {
            handler.resolve(response);
          }).catchError((e) {
            if (i == maxRetries - 1) {
              handler.reject(err);
            }
          });
        }
      } else {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
