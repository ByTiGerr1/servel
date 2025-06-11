import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:servel/models/user_model.dart';

class UserService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<UserProfile> getUserProfile() async {
    final token = await _storage.read(key: 'auth_token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
    final response = await http.get(
      Uri.parse('$_baseUrl/me/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } else {
      throw Exception('Fallo al obtener datos del usuario: ${response.statusCode}');
    }
  }
}
