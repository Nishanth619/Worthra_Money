import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'auth_token_store.dart';

/// Base URL is injected at build time so staging/production environments need
/// no code changes.
///
/// Build with:
///   flutter build apk --dart-define=API_BASE_URL=https://api.yourserver.com/v1
const _kDefaultBaseUrl = 'https://api.personalfinance.app/v1';
const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: _kDefaultBaseUrl,
);

/// Thin, production-ready HTTP client that handles:
///  - Bearer token injection
///  - Automatic silent token refresh on 401
///  - Typed [ApiException] for all non-2xx responses
///  - JSON encoding/decoding
class ApiClient {
  ApiClient({
    required AuthTokenStore tokenStore,
    http.Client? httpClient,
    String? baseUrl,
  })  : _tokenStore = tokenStore,
        _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? _apiBaseUrl;

  final AuthTokenStore _tokenStore;
  final http.Client _httpClient;
  final String _baseUrl;

  // ---------------------------------------------------------------------------
  // Public API surface
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> get(String path) async {
    return _request('GET', path);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request('POST', path, body: body);
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request('PUT', path, body: body);
  }

  Future<void> delete(String path) async {
    await _request('DELETE', path);
  }

  // ---------------------------------------------------------------------------
  // Auth helpers (used by AuthController, bypasses automatic token injection)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> postPublic(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request('POST', path, body: body, includeAuth: false);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
    bool isRetry = false,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _buildHeaders(includeAuth: includeAuth);

    http.Response response;

    try {
      response = await _sendRequest(method, uri, headers, body);
    } catch (e) {
      throw ApiException(statusCode: -1, message: 'Network error: $e');
    }

    // Attempt silent refresh on 401 — only once
    if (response.statusCode == 401 && includeAuth && !isRetry) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        return _request(method, path, body: body, isRetry: true);
      }
    }

    return _parseResponse(response);
  }

  Future<http.Response> _sendRequest(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    final encodedBody = body != null ? jsonEncode(body) : null;
    return switch (method) {
      'GET' => _httpClient.get(uri, headers: headers),
      'POST' => _httpClient.post(
          uri,
          headers: headers,
          body: encodedBody,
        ),
      'PUT' => _httpClient.put(
          uri,
          headers: headers,
          body: encodedBody,
        ),
      'DELETE' => _httpClient.delete(uri, headers: headers),
      _ => throw ArgumentError('Unknown HTTP method: $method'),
    };
  }

  Future<Map<String, String>> _buildHeaders({
    required bool includeAuth,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth) {
      final token = await _tokenStore.accessToken;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return const {};
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        return const {};
      }
    }

    final message = _extractErrorMessage(response.body) ??
        'Request failed with status $statusCode';
    throw ApiException(
      statusCode: statusCode,
      message: message,
      body: response.body,
    );
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      return decoded['message'] as String? ??
          decoded['error'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _tryRefreshToken() async {
    final refresh = await _tokenStore.refreshToken;
    if (refresh == null) return false;

    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;

        if (accessToken != null && refreshToken != null) {
          await _tokenStore.save(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: await _tokenStore.userId ?? '',
            userEmail: await _tokenStore.userEmail ?? '',
            userName: await _tokenStore.userName ?? '',
          );
          return true;
        }
      }
    } catch (_) {
      // Refresh failed — user must log in again
    }

    await _tokenStore.clear();
    return false;
  }
}
