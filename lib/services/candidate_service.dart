// lib/services/candidate_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // ¡Importante!
import 'package:servel/models/candidato_model.dart';
import 'package:servel/models/questionn_models.dart';
import 'package:servel/models/tipo_eleccion_model.dart';

class CandidateService {
  // Asegúrate de que esta sea la URL base de tu API de Django
  // Para emulador Android: 'http://10.0.2.2:8000/api'
  // Para iOS o dispositivo físico: 'http://<Tu_IP_Local>:8000/api'
  final String _baseUrl = 'http://10.0.2.2:8000/api'; // Cambia esto según tu configuración

  // Instancia de FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Método para obtener los headers, incluyendo el token de autenticación
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'auth_token'); // Lee el token de forma segura
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token', // Añade el token si existe
    };
  }

  // --- Servicio para TipoEleccion ---
  Future<List<TipoEleccion>> getTiposEleccion() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tipos-eleccion/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => TipoEleccion.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      // Manejo de error de autorización. Podrías redirigir al login aquí.
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar tipos de elección: ${response.statusCode}');
    }
  }

  // --- Servicio para Candidatos ---
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

  // --- Servicios para Preguntas y Respuestas de Usuario ---
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

  // --- Servicio para el Match de Candidatos ---
  Future<List<MatchResult>> getMatchCandidatos(int tipoEleccionId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/match-candidatos/?tipo_eleccion_id=$tipoEleccionId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MatchResult.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo al cargar el match de candidatos: ${response.statusCode}');
    }
  }

  // --- Servicios para Favoritos ---
  Future<List<CandidatoFavorito>> getFavoritos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/favoritos/'),
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
      Uri.parse('$_baseUrl/favoritos/'),
      headers: await _getHeaders(),
      body: json.encode({'candidato': candidatoId}),
    );

    if (response.statusCode != 201) {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Fallo al agregar favorito: ${response.statusCode} - $errorBody');
    }
  }

  Future<void> removeFavorito(int favoritoId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/favoritos/$favoritoId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Fallo al eliminar favorito: ${response.statusCode}');
    }
  }

  // --- Servicios para Descartados ---
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

  // --- Servicios para DecisionFinal ---
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