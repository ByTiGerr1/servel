import 'package:flutter/material.dart';
import 'package:servel/models/noticia_model.dart';
import 'package:servel/services/noticias_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Noticia>> _futureNoticias;
  final NoticiasApiService _apiService = NoticiasApiService();

  @override
  void initState() {
    super.initState();
    _futureNoticias = _apiService.getNoticias(); // Cargar noticias al iniciar
  }

  // Función para recargar las noticias
  Future<void> _refreshNoticias() async {
    setState(() {
      _futureNoticias = _apiService.getNoticias();
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNoticias, // Botón para recargar
          ),
        ],
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay noticias disponibles.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Noticia noticia = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noticia.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          noticia.descripcion,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Publicado: ${noticia.fechaPublicacion.day}/${noticia.fechaPublicacion.month}/${noticia.fechaPublicacion.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ejemplo de cómo crear una nueva noticia
          // En una app real, esto sería un formulario de entrada
          final newNoticia = Noticia(
            id: 0, // El ID será asignado por el backend
            titulo: 'Nueva Noticia desde Flutter ${DateTime.now().second}',
            descripcion: 'Esta es una noticia creada desde la app Flutter.',
            fechaPublicacion: DateTime.now(),
            actualizadoEn: DateTime.now(),
          );

          try {
            await _apiService.createNoticia(newNoticia);
            _refreshNoticias(); // Recargar la lista para ver la nueva noticia
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Noticia creada con éxito!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al crear noticia: $e')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}