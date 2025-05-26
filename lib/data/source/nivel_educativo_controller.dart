import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_flutter_crud/data/models/nivel_educativo_model.dart';
import 'dart:convert';

class NivelEducativoController
    extends StateNotifier<AsyncValue<List<NivelEducativo>>> {
  NivelEducativoController(this.ref) : super(const AsyncValue.loading()) {
    loadNivelesEducativos();
  }

  final Ref ref;
  final String baseUrl = 'http://192.168.18.69:3001/api/niveles-educativos';

  Future<void> loadNivelesEducativos() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final niveles =
            data.map((item) => NivelEducativo.fromJson(item)).toList();
        state = AsyncValue.data(niveles);
      } else {
        throw Exception(
            'Error al cargar niveles educativos: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createNivelEducativo(NivelEducativo nivel) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nivel.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Error al crear nivel educativo: ${response.statusCode}');
      }
      await loadNivelesEducativos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateNivelEducativo(String id, NivelEducativo nivel) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.18.69:3001/api/nivel-educativo/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nivel.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al actualizar nivel educativo: ${response.statusCode}');
      }
      await loadNivelesEducativos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteNivelEducativo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.18.69:3001/api/nivel-educativo/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al eliminar nivel educativo: ${response.statusCode}');
      }
      await loadNivelesEducativos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<NivelEducativo> getNivelEducativoById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.69:3001/api/nivel-educativo/$id'),
      );

      if (response.statusCode == 200) {
        return NivelEducativo.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Error al obtener nivel educativo: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
