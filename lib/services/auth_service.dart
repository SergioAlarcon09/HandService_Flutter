// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _baseUrl = 'https://tu-api.com/api'; // cambia por tu endpoint

  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      await _storage.write(key: 'token', value: token);
      return token;
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
