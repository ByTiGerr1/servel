// lib/services/candidate_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:servel/models/candidato_model.dart';
import 'package:servel/models/questionn_models.dart';
import 'package:servel/models/tipo_eleccion_model.dart';

class CandidateService {
  final String _baseUrl = 'http://10.0.2.2:8000/api'; 

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'auth_token'); 
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token', 
    };
  }

  Future<List<TipoEleccion>> getTiposEleccion() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tipos-eleccion/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => TipoEleccion.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar tipos de elección: ${response.statusCode}');
    }
  }

  Future<List<Candidato>> getCandidatos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/candidatos/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Candidato.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar candidatos: ${response.statusCode}');
    }
  }

  Future<Candidato> getCandidatoDetail(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/candidatos/$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Candidato.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar detalle del candidato: ${response.statusCode}');
    }
  }

  Future<List<Pregunta>> getPreguntasPendientes(int tipoEleccionId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/preguntas-pendientes/?tipo_eleccion_id=$tipoEleccionId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Pregunta.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar preguntas pendientes: ${response.statusCode}');
    }
  }

  Future<void> submitUserAnswers(List<UserAnswer> answers) async {
    final List<Map<String, dynamic>> answersJson = answers.map((answer) => answer.toJson()).toList();

    final response = await http.post(
      Uri.parse('$_baseUrl/submit-answers/'),
      headers: await _getHeaders(),
      body: json.encode(answersJson),
    );

    if (response.statusCode != 201) {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Fallo al enviar respuestas: ${response.statusCode} - $errorBody');
    }
  }

  Future<List<MatchResult>> getMatchCandidatos(int tipoEleccionId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/match-candidatos/?tipo_eleccion_id=$tipoEleccionId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      print('DEBUG: JSON de match-candidatos recibido: ${response.body}');
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MatchResult.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar el match de candidatos: ${response.statusCode}');
    }
  }

  Future<List<CandidatoFavorito>> getFavoritos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/candidatos-favoritos/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => CandidatoFavorito.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar favoritos: ${response.statusCode}');
    }
  }

  Future<void> addFavorito(int candidatoId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/candidatos-favoritos/'),
      headers: await _getHeaders(),
      body: json.encode({'candidato': candidatoId}),
    );

  if (response.statusCode == 200 || response.statusCode == 201) {
      print("Candidato agregado a favoritos correctamente.");
    } else {
        print("Error al agregar favorito. Código: ${response.statusCode}");
        print("Respuesta: ${response.body}");
      throw Exception("Error al agregar favorito");
    }
  }

  Future<void> removeFavorito(int favoritoId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/candidatos-favoritos/$favoritoId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Fallo al eliminar favorito: ${response.statusCode}');
    }
  }

  Future<List<CandidatoDescartado>> getDescartados() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/descartados/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => CandidatoDescartado.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar descartados: ${response.statusCode}');
    }
  }

  Future<void> addDescartado(int candidatoId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/descartados/'),
      headers: await _getHeaders(),
      body: json.encode({'candidato': candidatoId}),
    );

    if (response.statusCode != 201) {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Fallo al agregar descartado: ${response.statusCode} - $errorBody');
    }
  }

  Future<void> removeDescartado(int descartadoId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/descartados/$descartadoId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Fallo al eliminar descartado: ${response.statusCode}');
    }
  }

  Future<DecisionFinal> submitDecisionFinal(int candidatoElegidoId, int tipoEleccionId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/decisiones-finales/'),
      headers: await _getHeaders(),
      body: json.encode({
        'candidato_elegido': candidatoElegidoId,
        'tipo_eleccion': tipoEleccionId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return DecisionFinal.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Fallo al registrar decisión final: ${response.statusCode} - $errorBody');
    }
  }

  Future<List<DecisionFinal>> getDecisionesFinales() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/decisiones-finales/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => DecisionFinal.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar decisiones finales: ${response.statusCode}');
    }
  }
}