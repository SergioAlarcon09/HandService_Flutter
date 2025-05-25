import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/solicitud_model.dart';
import 'dart:convert';

class SolicitudController
    extends StateNotifier<AsyncValue<List<SolicitudServicio>>> {
  SolicitudController(this.ref) : super(const AsyncValue.loading()) {
    loadSolicitudes();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/solicitudes-servicios';

  Future<void> loadSolicitudes() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final solicitudes =
            data.map((item) => SolicitudServicio.fromJson(item)).toList();
        state = AsyncValue.data(solicitudes);
      } else {
        throw Exception('Error al cargar solicitudes: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createSolicitud(SolicitudServicio solicitud) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(solicitud.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear solicitud: ${response.statusCode}');
      }
      await loadSolicitudes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateSolicitud(String id, SolicitudServicio solicitud) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(solicitud.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al actualizar solicitud: ${response.statusCode}');
      }
      await loadSolicitudes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteSolicitud(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar solicitud: ${response.statusCode}');
      }
      await loadSolicitudes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<SolicitudServicio> getSolicitudById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return SolicitudServicio.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener solicitud: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<SolicitudServicio>> getSolicitudesByUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuario/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => SolicitudServicio.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener solicitudes: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
