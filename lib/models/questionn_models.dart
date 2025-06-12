class OpcionRespuesta {
  final int id;
  final String texto;
  final int valor;

  OpcionRespuesta({
    required this.id,
    required this.texto,
    required this.valor,
  });

  factory OpcionRespuesta.fromJson(Map<String, dynamic> json) {
    return OpcionRespuesta(
      id: json['id'],
      texto: json['texto'],
      valor: json['valor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'valor': valor,
    };
  }
}


class Pregunta {
  final int id;
  final String texto;
  final int orden;
  final int tipoEleccion;
  final String tipoEleccionNombre; 
  final List<OpcionRespuesta> opcionesRespuesta;

  Pregunta({
    required this.id,
    required this.texto,
    required this.orden,
    required this.tipoEleccion,
    required this.tipoEleccionNombre,
    required this.opcionesRespuesta,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    var list = json['opciones_respuesta'] as List;
    List<OpcionRespuesta> opcionesList =
        list.map((i) => OpcionRespuesta.fromJson(i)).toList();

    return Pregunta(
      id: json['id'],
      texto: json['texto'],
      orden: json['orden'],
      tipoEleccion: json['tipo_eleccion'],
      tipoEleccionNombre: json['tipo_eleccion_nombre'] ?? 'Desconocido', // Manejar nulos
      opcionesRespuesta: opcionesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'orden': orden,
      'tipo_eleccion': tipoEleccion,
      'tipo_eleccion_nombre': tipoEleccionNombre,
      'opciones_respuesta': opcionesRespuesta.map((e) => e.toJson()).toList(),
    };
  }
}


class UserAnswer {
  final int preguntaID;
  final int opcionElegidaID;

  UserAnswer({
    required this.preguntaID,
    required this.opcionElegidaID,
  });

  Map<String, dynamic> toJson() {
    return {
      'pregunta': preguntaID,
      'opcion_elegida': opcionElegidaID,
    };
  }
}