import 'package:flutter/material.dart';
import 'package:servel/services/user_service.dart';
import 'package:servel/models/user_model.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final UserService _userService = UserService();
  late Future<UserProfile> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = _userService.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos personales')),
      body: FutureBuilder<UserProfile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.username),
                  ),
                  if (user.email != null && user.email!.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email!),
                    ),
                  if (user.firstName != null && user.firstName!.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: Text('Nombre: ${user.firstName!}'),
                    ),
                  if (user.lastName != null && user.lastName!.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: Text('Apellido: ${user.lastName!}'),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}