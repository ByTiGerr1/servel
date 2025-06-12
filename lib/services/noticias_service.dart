import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servel/models/noticia_model.dart';

class NoticiasApiService {
  final String _baseUrl = 'http://10.0.2.2:8000/api/noticias/';

  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> noticiasJson = json.decode(utf8.decode(response.bodyBytes)); 
        return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load noticias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting noticias: $e');
    }
  }

  Future<Noticia> createNoticia(Noticia noticia) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(noticia.toJson()), 
      );

      if (response.statusCode == 201) {
        return Noticia.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to create noticia: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating noticia: $e');
    }
  }
}