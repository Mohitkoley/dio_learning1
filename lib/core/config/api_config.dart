class ApiConfig {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static String? _apiKey;

  static String get apiKey => _apiKey ??= getFromStorage();

  static String getFromStorage() {
    // Get the API key from secure storage
    return 'your_api';
  }
}
