import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:servel/models/questionn_models.dart';

class QuestionnaireService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = "http://10.0.2.2:8000/api/"; 

  QuestionnaireService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5); 
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          print('DEBUG: Token leído de storage: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Token $token';
            print('DEBUG: Encabezado de autorización configurado: ${options.headers['Authorization']}');
          }
          else {
            print('DEBUG: No se encontró token en storage. La petición se enviará sin autenticación.');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('Error en petición: ${e.response?.statusCode} - ${e.message}');
          if (e.response?.statusCode == 401) {
            print('DEBUG: Error 401: Credenciales de autenticación no proporcionadas o inválidas.');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<Pregunta>> getPendingQuestions({required int tipoEleccionId}) async {
    try {
      final response = await _dio.get(
        'preguntas/',
        queryParameters: {'tipo_eleccion_id': tipoEleccionId},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Pregunta.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error de respuesta: ${e.response?.data}');
        throw Exception('Server error: ${e.response?.data['detail'] ?? e.message}');
      } else {
        print('Error de conexión: ${e.message}');
        throw Exception('Connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> submitUserAnswers(List<UserAnswer> answers) async {
    try {
      final List<Map<String, dynamic>> answersJson =
          answers.map((answer) => answer.toJson()).toList();

      final response = await _dio.post(
        'respuestas/',
        data: answersJson, 
      );

      if (response.statusCode == 201) {
        print('Answers submitted successfully');
      } else {
        throw Exception('Failed to submit answers: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error de respuesta: ${e.response?.data}');
        throw Exception('Server error: ${e.response?.data['detail'] ?? e.message}');
      } else {
        print('Error de conexión: ${e.message}');
        throw Exception('Connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMatchResults({required int tipoEleccionId}) async {
    try {
      final response = await _dio.get(
        'match-candidatos/',
        queryParameters: {'tipo_eleccion_id': tipoEleccionId},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return List<Map<String, dynamic>>.from(data); 
      } else {
        throw Exception('Failed to load match results: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error de respuesta: ${e.response?.data}');
        throw Exception('Server error: ${e.response?.data['detail'] ?? e.message}');
      } else {
        print('Error de conexión: ${e.message}');
        throw Exception('Connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}