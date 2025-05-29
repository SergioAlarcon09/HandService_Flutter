class Puntuacion {
  final int? id;
  final int puntuacion;
  final int solicitudServicioId;
  final String? descripcion;
  final String? evidencia;

  Puntuacion({
    this.id,
    required this.puntuacion,
    required this.solicitudServicioId,
    this.descripcion,
    this.evidencia,
  });

  factory Puntuacion.fromJson(Map<String, dynamic> json) {
    return Puntuacion(
      id: json['id'],
      puntuacion: json['puntuacion'],
      solicitudServicioId: json['solicitud_servicio_id'],
      descripcion: json['descripcion'],
      evidencia: json['evidencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puntuacion': puntuacion,
      'solicitud_servicio_id': solicitudServicioId,
      'descripcion': descripcion,
      'evidencia': evidencia,
    };
  }
}