import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/solicitud_servicio_model.dart';

class SolicitudController extends StateNotifier<AsyncValue<List<Solicitud>>> {
  SolicitudController(this.ref) : super(const AsyncValue.loading()) {
    loadSolicitudes();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.1.4:3001/api/solicitudes-servicios';

  Future<void> loadSolicitudes() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Solicitud> solicitudes =
            data.map((item) => Solicitud.fromJson(item)).toList();
        state = AsyncValue.data(solicitudes);
      } else {
        throw Exception('Error al cargar las solicitudes');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSolicitud(Solicitud newSolicitud) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newSolicitud.toJson()),
      );

      if (response.statusCode == 201) {
        await loadSolicitudes();
      } else {
        throw Exception('Error al crear la solicitud');
      }
    } catch (error) {
      throw Exception('Error en addSolicitud: $error');
    }
  }

  Future<void> updateSolicitud(int? solicitudId, Solicitud updatedSolicitud) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$solicitudId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedSolicitud.toJson()),
      );

      if (response.statusCode == 200) {
        await loadSolicitudes();
      } else {
        throw Exception('Error al actualizar la solicitud');
      }
    } catch (error) {
      throw Exception('Error en updateSolicitud: $error');
    }
  }

  Future<void> deleteSolicitud(int? solicitudId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$solicitudId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        await loadSolicitudes();
      } else {
        throw Exception('Error al eliminar la solicitud');
      }
    } catch (error) {
      throw Exception('Error en deleteSolicitud: $error');
    }
  }

  Future<void> reloadSolicitudes() async {
    await loadSolicitudes();
  }
}