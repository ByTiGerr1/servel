
class Noticia {
  final int id;
  final String titulo;
  final String descripcion;
  final DateTime fechaPublicacion;
  final DateTime actualizadoEn;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaPublicacion,
    required this.actualizadoEn,
  });


  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fechaPublicacion: DateTime.parse(json['fecha_publicacion']),
      actualizadoEn: DateTime.parse(json['actualizado_en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha_publicacion': fechaPublicacion.toIso8601String(),
      'actualizado_en': actualizadoEn.toIso8601String(),
    };
  }
}