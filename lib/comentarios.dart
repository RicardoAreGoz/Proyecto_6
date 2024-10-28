class Comentario {
  final int id;
  final String peliculaId;
  final String usuarioId;
  final String comentario;
  final int calificacion;
  final DateTime createdAt;

  Comentario({
    required this.id,
    required this.peliculaId,
    required this.usuarioId,
    required this.comentario,
    required this.calificacion,
    required this.createdAt,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      peliculaId: json['pelicula_id'],
      usuarioId: json['usuario_id'],
      comentario: json['comentario'],
      calificacion: json['calificacion'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}