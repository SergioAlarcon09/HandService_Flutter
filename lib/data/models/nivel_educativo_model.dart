class NivelEducativo {
  final String? id;
  final String nombre;
  final String? descripcion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NivelEducativo({
    this.id,
    required this.nombre,
    this.descripcion,
    this.createdAt,
    this.updatedAt,
  });

  factory NivelEducativo.fromJson(Map<String, dynamic> json) {
    return NivelEducativo(
      id: json['_id'] ?? json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (id != null) 'id': id,
    };
  }

  NivelEducativo copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NivelEducativo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
