class TipoEleccion {
  final int id;
  final String nombre;
  final String? descripcion; // Puede ser nulo
  final DateTime? fechaEleccion; // Puede ser nulo

  TipoEleccion({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.fechaEleccion,
  });

  // Constructor factory para crear una instancia de TipoEleccion desde un JSON
  factory TipoEleccion.fromJson(Map<String, dynamic> json) {
    return TipoEleccion(
      id: json['id'] as int, // Casteo explícito a int
      nombre: json['nombre'] as String, // Casteo explícito a String
      // Para campos que pueden ser nulos, usamos 'as String?' y 'as String?'
      descripcion: json['descripcion'] as String?,
      fechaEleccion: json['fecha_eleccion'] != null
          ? DateTime.parse(json['fecha_eleccion'] as String) // Parsear la fecha si no es nula
          : null, // Si es nula en el JSON, asignamos null
    );
  }

  // Opcional: Método para convertir a JSON (útil si necesitas enviar este objeto a la API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_eleccion': fechaEleccion?.toIso8601String(), // Convertir DateTime a String ISO 8601
    };
  }
}