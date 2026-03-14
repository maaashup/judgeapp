class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? path;

  const ApiException({required this.message, this.statusCode, this.path});

  @override
  String toString() {
    if (statusCode != null && path != null) {
      return 'ApiException($statusCode, $path): $message';
    }
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}
