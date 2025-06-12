import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:servel/models/news_article_model.dart';
import 'package:servel/services/world_news_api_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<NewsArticle>> _futureNoticias;
  final WorldNewsApiService _apiService = WorldNewsApiService();

  @override
  void initState() {
    super.initState();
    _futureNoticias = _apiService.fetchTopHeadlines(); // Cargar noticias de Chile al iniciar
  }

  // Función para recargar las noticias
  Future<void> _refreshNoticias() async {
    setState(() {
      _futureNoticias = _apiService.fetchTopHeadlines();
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
      body: FutureBuilder<List<NewsArticle>>(
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
                final noticia = snapshot.data![index];
                final dateString = DateFormat('dd/MM/yyyy').format(noticia.publishedAt);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (noticia.imageUrl != null && noticia.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: noticia.imageUrl!,
                            fit: BoxFit.cover,
                            height: 180,
                            width: double.infinity,
                            placeholder: (context, url) => const SizedBox(
                              height: 180,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const SizedBox(
                              height: 180,
                              child: Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noticia.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            if (noticia.description != null && noticia.description!.isNotEmpty)
                              Text(
                                noticia.description!,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Publicado: $dateString',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      // Se eliminó la acción de crear noticias ya que las noticias se obtienen de un servicio externo
    );
  }
}