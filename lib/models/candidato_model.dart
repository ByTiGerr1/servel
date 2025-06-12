class Candidato {
  final int id;
  final String nombre;
  final String apellido;
  final String partido; 
  final String? bio; 
  final String ciudad;
  final String propuestaElectoral;
  final String? perfilePicture; 
  final List<int> tiposEleccion; 
  final List<String> tiposEleccionNombres; 

  Candidato({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.partido, 
    this.bio,
    required this.ciudad,
    required this.propuestaElectoral,
    this.perfilePicture,
    required this.tiposEleccion,
    required this.tiposEleccionNombres,
  });


  factory Candidato.fromJson(Map<String, dynamic> json) {
    return Candidato(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      partido: json['partido'] as String, 
      bio: json['bio'] as String?, 
      ciudad: json['ciudad'] as String,
      propuestaElectoral: json['propuesta_electoral'] as String,
      perfilePicture: json['perfile_picture'] as String?,
      tiposEleccion: List<int>.from(
        (json['tipos_eleccion'] as List<dynamic>?)?.map((e) => int.tryParse(e?.toString() ?? '0') ?? 0) ?? [],
      ),
      tiposEleccionNombres: List<String>.from(json['tipos_eleccion_nombres'] as List<dynamic>),
    );
  }

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
          : null, 
      matchPercentage: double.tryParse(json['match_percentage']?.toString() ?? '0.0') ?? 0.0,
      preguntasConsideradas: int.tryParse(json['preguntas_consideradas']?.toString() ?? '0') ?? 0,
    );
  }
}


class CandidatoFavorito {
  final int id;
  final int candidatoId; 
  final Candidato? candidatoData; 
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
          : null, 
      fechaAgregado: DateTime.parse(json['fecha_agregado'] as String),
    );
  }
}


class CandidatoDescartado {
  final int id;
  final int candidatoId; 
  final Candidato? candidatoData;
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


class DecisionFinal {
  final int id;
  final int userId;
  final int candidatoElegidoId;
  final Candidato? candidatoElegidoData; 
  final int tipoEleccionId;
  final String? tipoEleccionNombre; 
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
          : null, 
      tipoEleccionId: int.tryParse(json['tipo_eleccion']?.toString() ?? '0') ?? 0,
      tipoEleccionNombre: json['tipo_eleccion_nombre'] as String?, 
      fechaDecision: DateTime.parse(json['fecha_decision'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
     
      'candidato_elegido': candidatoElegidoId,
      'tipo_eleccion': tipoEleccionId,
  
    };
  }
}