import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/service_model.dart';

class ServiceController extends StateNotifier<AsyncValue<List<Service>>> {
  ServiceController(this.ref) : super(const AsyncValue.loading()) {
    loadServices();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.1.4:3001/api/services';

  Future<void> loadServices() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Service> services =
            data.map((item) => Service.fromJson(item)).toList();

        state = AsyncValue.data(services);
      } else {
        throw Exception('Error al cargar los servicios');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addService(Service newService) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newService.toJson()),
      );

      if (response.statusCode == 201) {
        await loadServices();
      } else {
        throw Exception('Error al agregar el servicio');
      }
    } catch (error) {
      throw Exception('Error en addService: $error');
    }
  }

  Future<void> updateService(int? serviceId, Service updatedService) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.1.4:3001/api/service/$serviceId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedService.toJson()),
      );

      if (response.statusCode == 200) {
        await loadServices();
      } else {
        throw Exception('Error al actualizar el servicio');
      }
    } catch (error) {
      throw Exception('Error en updateService: $error');
    }
  }

  Future<void> deleteService(int? serviceId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.4:3001/api/service/$serviceId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        await loadServices();
      } else {
        throw Exception('Error al eliminar el servicio');
      }
    } catch (error) {
      throw Exception('Error en deleteService: $error');
    }
  }

  Future<void> reloadServices() async {
    await loadServices();
  }
}
