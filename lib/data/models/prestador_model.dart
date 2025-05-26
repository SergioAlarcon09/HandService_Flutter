class Prestador {
  final String? id;
  final String nombre;
  final String especialidad;
  final String telefono;
  final String email;
  final String? direccion;
  final List<String>? servicios;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Prestador({
    this.id,
    required this.nombre,
    required this.especialidad,
    required this.telefono,
    required this.email,
    this.direccion,
    this.servicios,
    this.createdAt,
    this.updatedAt,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['_id'] ?? json['id'],
      nombre: json['nombre'],
      especialidad: json['especialidad'],
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      servicios: json['servicios'] != null
          ? List<String>.from(json['servicios'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'especialidad': especialidad,
      'telefono': telefono,
      'email': email,
      if (direccion != null) 'direccion': direccion,
      if (servicios != null) 'servicios': servicios,
      if (id != null) 'id': id,
    };
  }

  Prestador copyWith({
    String? id,
    String? nombre,
    String? especialidad,
    String? telefono,
    String? email,
    String? direccion,
    List<String>? servicios,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Prestador(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      especialidad: especialidad ?? this.especialidad,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      servicios: servicios ?? this.servicios,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
