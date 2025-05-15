class Service {
  final int? id;
  final String nombre;
  final String descripcion;
  final double valor;
  final bool estado;

  Service({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.valor,
    this.estado = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      valor: double.tryParse(json['valor'].toString()) ?? 0.0,
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'valor': valor,
      'estado': estado,
    };
  }
}