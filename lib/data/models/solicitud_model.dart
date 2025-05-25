class SolicitudServicio {
  final String? id;
  final String servicioId;
  final String clienteId;
  final String prestadorId;
  final DateTime fechaSolicitud;
  final String estado; // 'pendiente', 'aceptada', 'rechazada', 'completada'
  final String? detalles;
  final DateTime? fechaAtencion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SolicitudServicio({
    this.id,
    required this.servicioId,
    required this.clienteId,
    required this.prestadorId,
    required this.fechaSolicitud,
    this.estado = 'pendiente',
    this.detalles,
    this.fechaAtencion,
    this.createdAt,
    this.updatedAt,
  });

  factory SolicitudServicio.fromJson(Map<String, dynamic> json) {
    return SolicitudServicio(
      id: json['_id'] ?? json['id'],
      servicioId: json['servicioId'],
      clienteId: json['clienteId'],
      prestadorId: json['prestadorId'],
      fechaSolicitud: DateTime.parse(json['fechaSolicitud']),
      estado: json['estado'],
      detalles: json['detalles'],
      fechaAtencion: json['fechaAtencion'] != null
          ? DateTime.parse(json['fechaAtencion'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicioId': servicioId,
      'clienteId': clienteId,
      'prestadorId': prestadorId,
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
      'estado': estado,
      if (detalles != null) 'detalles': detalles,
      if (fechaAtencion != null)
        'fechaAtencion': fechaAtencion!.toIso8601String(),
      if (id != null) 'id': id,
    };
  }

  SolicitudServicio copyWith({
    String? id,
    String? servicioId,
    String? clienteId,
    String? prestadorId,
    DateTime? fechaSolicitud,
    String? estado,
    String? detalles,
    DateTime? fechaAtencion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SolicitudServicio(
      id: id ?? this.id,
      servicioId: servicioId ?? this.servicioId,
      clienteId: clienteId ?? this.clienteId,
      prestadorId: prestadorId ?? this.prestadorId,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      estado: estado ?? this.estado,
      detalles: detalles ?? this.detalles,
      fechaAtencion: fechaAtencion ?? this.fechaAtencion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
