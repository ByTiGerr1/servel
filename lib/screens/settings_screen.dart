import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Antonio Mas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'CUENTA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            _buildSettingTile(Icons.person_outline, 'Detalles Personales'),
            const SizedBox(height: 24),
            const Text(
              'CONFIGURACION',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            _buildSettingTile(Icons.notifications_none, 'Notificaciones'),
            _buildSettingTile(Icons.language, 'Lenguaje'),
            _buildSettingTile(Icons.headphones_outlined, 'Ayuda y Soporte'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Cerrar Sesion',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
