class Prestador {
  final int? id;
  final String profesion;
  final int nivelEducativoId;
  final int usuarioId;

  Prestador({
    this.id,
    required this.profesion,
    required this.nivelEducativoId,
    required this.usuarioId,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'],
      profesion: json['profesion'],
      nivelEducativoId: json['nivel_educativo_id'],
      usuarioId: json['usuario_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profesion': profesion,
      'nivel_educativo_id': nivelEducativoId,
      'usuario_id': usuarioId,
    };
  }
}