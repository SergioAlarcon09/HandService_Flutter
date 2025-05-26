import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/puntuacion_model.dart';
import 'dart:convert';

class PuntuacionController extends StateNotifier<AsyncValue<List<Puntuacion>>> {
  PuntuacionController(this.ref) : super(const AsyncValue.loading()) {
    loadPuntuaciones();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/puntuaciones';

  Future<void> loadPuntuaciones() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final puntuaciones =
            data.map((item) => Puntuacion.fromJson(item)).toList();
        state = AsyncValue.data(puntuaciones);
      } else {
        throw Exception('Error al cargar puntuaciones: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createPuntuacion(Puntuacion puntuacion) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(puntuacion.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear puntuación: ${response.statusCode}');
      }
      await loadPuntuaciones();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updatePuntuacion(String id, Puntuacion puntuacion) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(puntuacion.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al actualizar puntuación: ${response.statusCode}');
      }
      await loadPuntuaciones();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deletePuntuacion(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar puntuación: ${response.statusCode}');
      }
      await loadPuntuaciones();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Puntuacion> getPuntuacionById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return Puntuacion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener puntuación: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<double> getPromedioPuntuaciones(String servicioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/servicio/$servicioId/promedio'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['promedio'].toDouble();
      } else {
        throw Exception('Error al obtener promedio: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
