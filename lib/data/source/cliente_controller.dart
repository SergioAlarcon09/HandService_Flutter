import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/cliente_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteController extends StateNotifier<AsyncValue<List<Cliente>>> {
  ClienteController(this.ref) : super(const AsyncValue.loading()) {
    loadClientes();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/clientes';

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> loadClientes() async {
    try {
      state = const AsyncValue.loading();
      final headers = await _getAuthHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final clientes = data.map((item) => Cliente.fromJson(item)).toList();
        state = AsyncValue.data(clientes);
      } else {
        throw Exception('Error al cargar clientes: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createCliente(Cliente cliente) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(cliente.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear cliente: ${response.statusCode}');
      }
      await loadClientes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateCliente(String id, Cliente cliente) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: jsonEncode(cliente.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar cliente: ${response.statusCode}');
      }
      await loadClientes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteCliente(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar cliente: ${response.statusCode}');
      }
      await loadClientes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Cliente> getClienteById(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Cliente.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener cliente: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
