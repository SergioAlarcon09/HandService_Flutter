class Puntuacion {
  final String? id;
  final String servicioId;
  final String usuarioId;
  final int valor;
  final String? comentario;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Puntuacion({
    this.id,
    required this.servicioId,
    required this.usuarioId,
    required this.valor,
    this.comentario,
    this.createdAt,
    this.updatedAt,
  });

  factory Puntuacion.fromJson(Map<String, dynamic> json) {
    return Puntuacion(
      id: json['_id'] ?? json['id'],
      servicioId: json['servicioId'],
      usuarioId: json['usuarioId'],
      valor: json['valor'],
      comentario: json['comentario'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicioId': servicioId,
      'usuarioId': usuarioId,
      'valor': valor,
      if (comentario != null) 'comentario': comentario,
      if (id != null) 'id': id,
    };
  }

  Puntuacion copyWith({
    String? id,
    String? servicioId,
    String? usuarioId,
    int? valor,
    String? comentario,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Puntuacion(
      id: id ?? this.id,
      servicioId: servicioId ?? this.servicioId,
      usuarioId: usuarioId ?? this.usuarioId,
      valor: valor ?? this.valor,
      comentario: comentario ?? this.comentario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
