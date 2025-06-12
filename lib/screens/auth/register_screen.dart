import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController(); 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  bool _isLoading = false; 

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String _baseUrl = 'http://10.0.2.2:8000/api'; 

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating, 
        margin: const EdgeInsets.all(10), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }


  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    final String username = _usernameController.text.trim(); 
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register/'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (!mounted) return; 

      if (response.statusCode == 201) { 
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];

       
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'username', value: username);
        _showSnackBar('Registro exitoso. ¡Bienvenido!');
        Navigator.pushReplacementNamed(context, '/login'); 
      } else {
        String errorMessage = 'Error al registrar usuario.';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('username')) {
            errorMessage += '\nUsuario: ${errorData['username'][0]}';
          }
          if (errorData.containsKey('email')) {
            errorMessage += '\nEmail: ${errorData['email'][0]}';
          }
          if (errorData.containsKey('password')) {
            errorMessage += '\nContraseña: ${errorData['password'][0]}';
          }
          if (errorData.containsKey('non_field_errors')) {
            errorMessage += '\n${errorData['non_field_errors'][0]}';
          }
        } catch (e) {
          print('Respuesta de error no JSON o inesperada: ${response.body}');
          errorMessage += '\nDetalles: ${response.body}';
        }
        _showSnackBar(errorMessage, isError: true);
        print('Registro fallido: ${response.statusCode} - ${response.body}'); 
      }
    } catch (e) {
      _showSnackBar('Error de conexión. Verifica tu conexión a internet.', isError: true);
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form( 
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                const Text(
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre de usuario';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator()) 
                    : ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe2000d), 
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    '¿Ya tienes una cuenta? Inicia Sesión',
                    style: TextStyle(color: Color(0xffe2000d)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}