/// Typed exception thrown by [ApiClient] for any non-2xx HTTP response
/// or network-level failures.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  /// HTTP status code, or -1 for connectivity/timeout errors.
  final int statusCode;
  final String message;

  /// Raw response body, if any.
  final String? body;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isNetworkError => statusCode == -1;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
