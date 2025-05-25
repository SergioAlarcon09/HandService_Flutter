import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/prestador_model.dart';
import 'dart:convert';

class PrestadorController extends StateNotifier<AsyncValue<List<Prestador>>> {
  PrestadorController(this.ref) : super(const AsyncValue.loading()) {
    loadPrestadores();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/prestadores-servicios';

  Future<void> loadPrestadores() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final prestadores =
            data.map((item) => Prestador.fromJson(item)).toList();
        state = AsyncValue.data(prestadores);
      } else {
        throw Exception('Error al cargar prestadores: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createPrestador(Prestador prestador) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prestador.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear prestador: ${response.statusCode}');
      }
      await loadPrestadores();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updatePrestador(String id, Prestador prestador) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prestador.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al actualizar prestador: ${response.statusCode}');
      }
      await loadPrestadores();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deletePrestador(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar prestador: ${response.statusCode}');
      }
      await loadPrestadores();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Prestador> getPrestadorById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return Prestador.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener prestador: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
