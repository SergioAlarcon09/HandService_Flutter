class Solicitud {
  final int? id;
  final int servicioId;
  final int tiempoEstimado;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final int cantidad;
  final double valor;
  final int clienteId;
  final int? prestadorServicioId;
  final String estado;

  Solicitud({
    this.id,
    required this.servicioId,
    required this.tiempoEstimado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.cantidad,
    required this.valor,
    required this.clienteId,
    required this.prestadorServicioId,
    required this.estado,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'] as int?,
      servicioId: json['servicio_id'] as int,
      tiempoEstimado: json['tiempo_estimado'] as int,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: json['fecha_fin'] != null
          ? DateTime.parse(json['fecha_fin'] as String)
          : null,
      cantidad: json['cantidad'] as int,
      valor: double.parse(json['valor'].toString()),
      clienteId: json['cliente_id'] as int,
      prestadorServicioId: json['prestador_servicio_id'] as int?,
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servicio_id': servicioId,
      'tiempo_estimado': tiempoEstimado,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'cantidad': cantidad,
      'valor': valor,
      'cliente_id': clienteId,
      'prestador_servicio_id': prestadorServicioId,
      'estado': estado,
    };
  }
}
