enum ResponseType {
  sucess,
  error,
  loading,
}

enum KResponseType {
  sucess,
  error,
  loading,
  empty,
}

class KResponse<T> {
  final KResponseType type;
  final dynamic data;
  final String? message;

  KResponse({
    this.type = KResponseType.loading,
    this.data,
    this.message,
  });

  KResponse<T> copyWithLoading() {
    return KResponse<T>(
      type: KResponseType.loading,
      data: data,
      message: message,
    );
  }

  KResponse<T> copyWithSuccess(T data) {
    return KResponse<T>(
      type: KResponseType.sucess,
      data: data,
      message: message,
    );
  }

  KResponse<T> copyWithError(String message) {
    return KResponse<T>(
      type: KResponseType.error,
      data: data,
      message: message,
    );
  }
}
