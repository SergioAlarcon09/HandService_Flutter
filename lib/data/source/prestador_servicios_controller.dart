import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prestador_servicios_model.dart';

class PrestadorController extends StateNotifier<AsyncValue<List<Prestador>>> {
  PrestadorController(this.ref) : super(const AsyncValue.loading()) {
    loadPrestadores();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.1.4:3001/api/prestadores-servicios';

  Future<void> loadPrestadores() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Prestador> prestadores =
            data.map((item) => Prestador.fromJson(item)).toList();
        state = AsyncValue.data(prestadores);
      } else {
        throw Exception('Error al cargar los prestadores');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPrestador(Prestador newPrestador) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newPrestador.toJson()),
      );

      if (response.statusCode == 201) {
        await loadPrestadores();
      } else {
        throw Exception('Error al agregar el prestador');
      }
    } catch (error) {
      throw Exception('Error en addPrestador: $error');
    }
  }

  Future<void> updatePrestador(int? id, Prestador updatedPrestador) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedPrestador.toJson()),
      );

      if (response.statusCode == 200) {
        await loadPrestadores();
      } else {
        throw Exception('Error al actualizar el prestador');
      }
    } catch (error) {
      throw Exception('Error en updatePrestador: $error');
    }
  }

  Future<void> deletePrestador(int? id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        await loadPrestadores();
      } else {
        throw Exception('Error al eliminar el prestador');
      }
    } catch (error) {
      throw Exception('Error en deletePrestador: $error');
    }
  }
}
