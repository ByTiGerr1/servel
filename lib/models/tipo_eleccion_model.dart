class TipoEleccion {
  final int id;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaEleccion; 

  TipoEleccion({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.fechaEleccion,
  });


  factory TipoEleccion.fromJson(Map<String, dynamic> json) {
    return TipoEleccion(
      id: json['id'] as int,
      nombre: json['nombre'] as String, 
     
      descripcion: json['descripcion'] as String?,
      fechaEleccion: json['fecha_eleccion'] != null
          ? DateTime.parse(json['fecha_eleccion'] as String) 
          : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_eleccion': fechaEleccion?.toIso8601String(), 
    };
  }
}