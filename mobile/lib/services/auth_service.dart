
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Android emulator connects to the backend on your Windows computer.
  static const String baseUrl = 'https://mandi-marketplace-api.vercel.app';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    required String role,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'full_name': fullName.trim(),
            'email': email.trim().toLowerCase(),
            'password': password,
            if (phone != null && phone.trim().isNotEmpty)
              'phone': phone.trim(),
            'role': role.toLowerCase(),
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message'] ?? 'Registration failed. Please try again.',
      );
    }

    return data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim().toLowerCase(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['message'] ?? 'Login failed.');
    }

    final token = data['token'];

    if (token is! String || token.isEmpty) {
      throw Exception('The server did not return a login token.');
    }

    await _storage.write(key: _tokenKey, value: token);

    return data;
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Please log in first.');
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl/api/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 15));

    final data = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 401) {
        await logout();
      }
      throw Exception(data['message'] ?? 'Unable to load your account.');
    }

    return data;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      // The server may return a non-JSON response.
    }

    throw Exception(
      'The server returned an invalid response '
      '(HTTP ${response.statusCode}).',
    );
  }
}
