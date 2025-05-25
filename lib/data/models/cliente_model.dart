class Cliente {
  final String? id;
  final String nombre;
  final String email;
  final String telefono;
  final String direccion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cliente({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
    this.createdAt,
    this.updatedAt,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['_id'] ?? json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      if (id != null) 'id': id,
    };
  }

  Cliente copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
