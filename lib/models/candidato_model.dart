class Candidato {
  final int id;
  final String nombre;
  final String apellido;
  final String partido; // Añadido
  final String? bio; // Puede ser null
  final String ciudad;
  final String propuestaElectoral;
  final String? perfilePicture; // URL de la imagen, puede ser null
  final List<int> tiposEleccion; // IDs de los tipos de elección a los que pertenece
  final List<String> tiposEleccionNombres; // Nombres de los tipos de elección

  Candidato({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.partido, // Añadido
    this.bio,
    required this.ciudad,
    required this.propuestaElectoral,
    this.perfilePicture,
    required this.tiposEleccion,
    required this.tiposEleccionNombres,
  });

  // Constructor factory para crear una instancia de Candidato desde un JSON
  factory Candidato.fromJson(Map<String, dynamic> json) {
    return Candidato(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      partido: json['partido'] as String, // Asegúrate de que el campo 'partido' esté presente en el JSON
      bio: json['bio'] as String?, // Usar 'as String?' para campos que pueden ser null
      ciudad: json['ciudad'] as String,
      propuestaElectoral: json['propuesta_electoral'] as String,
      // `perfile_picture` puede ser null si no hay imagen
      perfilePicture: json['perfile_picture'] as String?,
      // Castear a List<dynamic> y luego mapear a List<int>
      tiposEleccion: List<int>.from(
        (json['tipos_eleccion'] as List<dynamic>?)?.map((e) => int.tryParse(e?.toString() ?? '0') ?? 0) ?? [],
      ),
      // Castear a List<dynamic> y luego mapear a List<String>
      tiposEleccionNombres: List<String>.from(json['tipos_eleccion_nombres'] as List<dynamic>),
    );
  }

  // Opcional: Método para convertir a JSON (útil si necesitas enviar datos de Candidato a la API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'partido': partido,
      'bio': bio,
      'ciudad': ciudad,
      'propuesta_electoral': propuestaElectoral,
      'perfile_picture': perfilePicture,
      'tipos_eleccion': tiposEleccion,
      'tipos_eleccion_nombres': tiposEleccionNombres,
    };
  }
}

// -----------------------------------------------------------------------------
// Modelos relacionados con el Match, Favoritos y Descartados (si no los tienes ya)
// -----------------------------------------------------------------------------

// Modelo para el resultado del Match (usado en MatchCandidatosView)
class MatchResult {
  final Candidato? candidato;
  final double matchPercentage;
  final int preguntasConsideradas;

  MatchResult({
    this.candidato,
    required this.matchPercentage,
    required this.preguntasConsideradas,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      candidato: json['candidato_data'] != null 
          ? Candidato.fromJson(json['candidato_data'] as Map<String, dynamic>)
          : null, // Si es null, asigna null
      matchPercentage: double.tryParse(json['match_percentage']?.toString() ?? '0.0') ?? 0.0,
      preguntasConsideradas: int.tryParse(json['preguntas_consideradas']?.toString() ?? '0') ?? 0,
    );
  }
}

// Modelo para CandidatoFavorito (si se devuelve en las listas de favoritos)
class CandidatoFavorito {
  final int id;
  final int candidatoId; // ID del candidato favorito
  final Candidato? candidatoData; // Detalles del candidato (si el serializador lo incluye)
  final DateTime fechaAgregado;

  CandidatoFavorito({
    required this.id,
    required this.candidatoId,
    this.candidatoData,
    required this.fechaAgregado,
  });

  factory CandidatoFavorito.fromJson(Map<String, dynamic> json) {
    return CandidatoFavorito(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      candidatoId: int.tryParse(json['candidato']?.toString() ?? '0') ?? 0,
      candidatoData: json['candidato_data'] != null
          ? Candidato.fromJson(json['candidato_data'] as Map<String, dynamic>)
          : null, // Si el backend envía 'candidato_data', parselo
      fechaAgregado: DateTime.parse(json['fecha_agregado'] as String),
    );
  }
}

// Modelo para CandidatoDescartado (si se devuelve en las listas de descartados)
class CandidatoDescartado {
  final int id;
  final int candidatoId; // ID del candidato descartado
  final Candidato? candidatoData; // Detalles del candidato (si el serializador lo incluye)
  final DateTime fechaDescartado;

  CandidatoDescartado({
    required this.id,
    required this.candidatoId,
    this.candidatoData,
    required this.fechaDescartado,
  });

  factory CandidatoDescartado.fromJson(Map<String, dynamic> json) {
    return CandidatoDescartado(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      candidatoId: int.tryParse(json['candidato']?.toString() ?? '0') ?? 0,
      candidatoData: json['candidato_data'] != null
          ? Candidato.fromJson(json['candidato_data'] as Map<String, dynamic>)
          : null,
      fechaDescartado: DateTime.parse(json['fecha_descartado'] as String),
    );
  }
}

// Modelo para DecisionFinal
class DecisionFinal {
  final int id;
  final int userId;
  final int candidatoElegidoId;
  final Candidato? candidatoElegidoData; // Opcional, si quieres los detalles del candidato elegido
  final int tipoEleccionId;
  final String? tipoEleccionNombre; // Añadido para mostrar el nombre del tipo de elección
  final DateTime fechaDecision;

  DecisionFinal({
    required this.id,
    required this.userId,
    required this.candidatoElegidoId,
    this.candidatoElegidoData,
    required this.tipoEleccionId,
    this.tipoEleccionNombre,
    required this.fechaDecision,
  });

  factory DecisionFinal.fromJson(Map<String, dynamic> json) {
    return DecisionFinal(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user']?.toString() ?? '0') ?? 0,
      candidatoElegidoId: int.tryParse(json['candidato_elegido']?.toString() ?? '0') ?? 0,
      candidatoElegidoData: json['candidato_elegido_data'] != null
          ? Candidato.fromJson(json['candidato_elegido_data'] as Map<String, dynamic>)
          : null, // Si incluyes esto en el serializador de Django
      tipoEleccionId: int.tryParse(json['tipo_eleccion']?.toString() ?? '0') ?? 0,
      tipoEleccionNombre: json['tipo_eleccion_nombre'] as String?, // Asegúrate que el backend lo envíe
      fechaDecision: DateTime.parse(json['fecha_decision'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Cuando envías una decisión final, solo necesitas estos IDs
      'candidato_elegido': candidatoElegidoId,
      'tipo_eleccion': tipoEleccionId,
      // El 'user' se asigna en el backend
    };
  }
}