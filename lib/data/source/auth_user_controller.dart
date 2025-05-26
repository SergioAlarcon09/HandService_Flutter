import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/auth_user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserController extends StateNotifier<AsyncValue<AuthUser?>> {
  AuthUserController(this.ref) : super(const AsyncValue.data(null)) {
    loadCurrentUser();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/auth';

  // ==================== MÉTODOS PRINCIPALES ====================

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      await _handleAuthResponse(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      await _handleAuthResponse(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = const AsyncValue.data(null);
  }

  // ==================== MÉTODOS AUXILIARES ====================

  Future<void> loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }

      state = const AsyncValue.loading();
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        final user = AuthUser.fromJson(json.decode(response.body));
        state = AsyncValue.data(user.copyWith(token: token));
      } else {
        await prefs.remove('token');
        state = const AsyncValue.data(null);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _handleAuthResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final user = AuthUser.fromJson(data['user']);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      state = AsyncValue.data(user.copyWith(token: token));
    } else {
      throw _parseError(response);
    }
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Exception _parseError(http.Response response) {
    try {
      final error = json.decode(response.body);
      return Exception(error['message'] ?? 'Error desconocido');
    } catch (_) {
      return Exception(
          'Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // ==================== ADMIN METHODS ====================

  Future<List<AuthUser>> getAllUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: _authHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => AuthUser.fromJson(item)).toList();
    } else {
      throw _parseError(response);
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('No autenticado');
    return token;
  }
}
