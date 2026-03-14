import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/exceptions/api_exception.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  String get baseUrl => AppConfig.apiBaseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<dynamic> get(
    String path, {
    List<int> expectedStatusCodes = const [200],
  }) async {
    try {
      final response = await http
          .get(_uri(path), headers: _headers)
          .timeout(_timeout);

      _ensureSuccess(
        response,
        expected: expectedStatusCodes,
        action: 'GET',
        path: path,
      );

      return _decodeBody(response.body);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out', path: path);
    }
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    List<int> expectedStatusCodes = const [200, 201],
  }) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: _headers,
            body: body == null ? null : json.encode(body),
          )
          .timeout(_timeout);

      _ensureSuccess(
        response,
        expected: expectedStatusCodes,
        action: 'POST',
        path: path,
      );

      return _decodeBody(response.body);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out', path: path);
    }
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    List<int> expectedStatusCodes = const [200],
  }) async {
    try {
      final response = await http
          .put(
            _uri(path),
            headers: _headers,
            body: body == null ? null : json.encode(body),
          )
          .timeout(_timeout);

      _ensureSuccess(
        response,
        expected: expectedStatusCodes,
        action: 'PUT',
        path: path,
      );

      return _decodeBody(response.body);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out', path: path);
    }
  }

  Future<void> delete(
    String path, {
    List<int> expectedStatusCodes = const [200, 204],
  }) async {
    try {
      final response = await http
          .delete(_uri(path), headers: _headers)
          .timeout(_timeout);

      _ensureSuccess(
        response,
        expected: expectedStatusCodes,
        action: 'DELETE',
        path: path,
      );
    } on TimeoutException {
      throw ApiException(message: 'Request timed out', path: path);
    }
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;

    try {
      return json.decode(body);
    } catch (_) {
      return body;
    }
  }

  void _ensureSuccess(
    http.Response response, {
    required List<int> expected,
    required String action,
    required String path,
  }) {
    if (expected.contains(response.statusCode)) return;

    throw ApiException(
      message: _errorMessage(response),
      statusCode: response.statusCode,
      path: path,
    );
  }

  String _errorMessage(http.Response response) {
    final parsed = _decodeBody(response.body);

    if (parsed is Map<String, dynamic>) {
      final message = parsed['message'] ?? parsed['error'] ?? parsed['detail'];
      if (message != null) return message.toString();
    }

    if (response.body.trim().isNotEmpty) {
      return response.body;
    }

    return 'Request failed';
  }
}
