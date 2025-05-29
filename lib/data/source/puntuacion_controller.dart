import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/puntuacion_model.dart';

class PuntuacionController extends StateNotifier<AsyncValue<List<Puntuacion>>> {
  PuntuacionController(this.ref) : super(const AsyncValue.loading()) {
    loadPuntuaciones();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.1.4:3001/api/puntuaciones';

  Future<void> loadPuntuaciones() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Puntuacion> puntuaciones =
            data.map((item) => Puntuacion.fromJson(item)).toList();
        state = AsyncValue.data(puntuaciones);
      } else {
        throw Exception('Error al cargar las puntuaciones');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPuntuacion(Puntuacion newPuntuacion) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newPuntuacion.toJson()),
      );

      if (response.statusCode == 201) {
        await loadPuntuaciones();
      } else {
        throw Exception('Error al agregar la puntuación');
      }
    } catch (error) {
      throw Exception('Error en addPuntuacion: $error');
    }
  }

  Future<void> updatePuntuacion(
      int? puntuacionId, Puntuacion updatedPuntuacion) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$puntuacionId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedPuntuacion.toJson()),
      );

      if (response.statusCode == 200) {
        await loadPuntuaciones();
      } else {
        throw Exception('Error al actualizar la puntuación');
      }
    } catch (error) {
      throw Exception('Error en updatePuntuacion: $error');
    }
  }

  Future<void> deletePuntuacion(int? puntuacionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$puntuacionId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        await loadPuntuaciones();
      } else {
        throw Exception('Error al eliminar la puntuación');
      }
    } catch (error) {
      throw Exception('Error en deletePuntuacion: $error');
    }
  }

  Future<void> reloadPuntuaciones() async {
    await loadPuntuaciones();
  }
}
