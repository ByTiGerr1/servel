import 'package:flutter/material.dart';
import 'package:servel/models/candidato_model.dart';
import 'package:servel/services/candidate_service.dart';

class FavoritesCandidatesScreen extends StatefulWidget {
  const FavoritesCandidatesScreen({super.key});

  @override
  State<FavoritesCandidatesScreen> createState() => _FavoritesCandidatesScreenState();
}

class _FavoritesCandidatesScreenState extends State<FavoritesCandidatesScreen> {
  late Future<List<CandidatoFavorito>> _futureCandidatosFavoritos;
  final CandidateService _apiService = CandidateService();

  
  @override
  void initState() {
    super.initState();
    _futureCandidatosFavoritos = _apiService.getFavoritos();
  }

    Future<void> _refreshCandidatosFavoritos() async {
    setState(() {
      _futureCandidatosFavoritos = _apiService.getFavoritos();
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
            onPressed: _refreshCandidatosFavoritos,
          ),
        ],
      ),
      body: FutureBuilder<List<CandidatoFavorito>>(
        future: _futureCandidatosFavoritos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes candidatos favoritos aún.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CandidatoFavorito favorito = snapshot.data![index];
                Candidato candidato = favorito.candidatoData!; 

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${candidato.nombre} ${candidato.apellido}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Partido: ${candidato.partido}',
                          style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 163, 40, 40)),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Ciudad: ${candidato.ciudad}',
                          style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 108, 31, 31)),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Bio: ${candidato.bio}',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (candidato.perfilePicture != null && candidato.perfilePicture!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.network(
                              candidato.perfilePicture!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 100, color: Colors.grey);
                              },
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Agregado el: ${favorito.fechaAgregado.day}/${favorito.fechaAgregado.month}/${favorito.fechaAgregado.year}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
      // Puedes añadir un FloatingActionButton para añadir/eliminar favoritos si lo implementas
    );
  }
}