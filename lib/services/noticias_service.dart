// lib/services/noticias_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servel/models/noticia_model.dart';

class NoticiasApiService {
  // Asegúrate de que esta URL coincida con la de tu API de Django
  final String _baseUrl = 'http://10.0.2.2:8000/api/noticias/';

  // Método para obtener todas las noticias
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa (código 200 OK)
        List<dynamic> noticiasJson = json.decode(utf8.decode(response.bodyBytes)); // Decodifica bytes a UTF-8 y luego a JSON
        return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
      } else {
        // Si la respuesta no es 200 OK, lanza una excepción
        throw Exception('Failed to load noticias: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores de red o cualquier otra excepción
      throw Exception('Error getting noticias: $e');
    }
  }

  // Método para crear una nueva noticia
  Future<Noticia> createNoticia(Noticia noticia) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(noticia.toJson()), // Convierte el objeto Noticia a JSON string
      );

      if (response.statusCode == 201) { // 201 Created para POST exitoso
        return Noticia.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to create noticia: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating noticia: $e');
    }
  }

  // Puedes añadir más métodos para PUT (actualizar), DELETE, etc.
}