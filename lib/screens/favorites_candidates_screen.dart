import 'package:flutter/material.dart';
import 'package:servel/models/candidato_model.dart';
import 'package:servel/screens/match/candidate_detail_screen.dart';
import 'package:servel/services/candidate_service.dart';
import 'package:tcard/tcard.dart';

class FavoritesCandidatesScreen extends StatefulWidget {
  const FavoritesCandidatesScreen({super.key});

  @override
  State<FavoritesCandidatesScreen> createState() => _FavoritesCandidatesScreenState();
}

class _FavoritesCandidatesScreenState extends State<FavoritesCandidatesScreen> {
  late Future<List<CandidatoFavorito>> _futureCandidatosFavoritos;
  late Future<List<CandidatoDescartado>> _futureCandidatosDescartados;
  final CandidateService _apiService = CandidateService();
  bool _descartadosExpanded = false;

  Future<void> _removeFavorito(int favoritoId) async {
    try {
      await _apiService.removeFavorito(favoritoId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Eliminado de favoritos")),
        );
        _refreshCandidatosFavoritos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar favorito: $e")),
      );
    }
  }

  Future<void> _removeDescartado(int descartadoId) async {
    try {
      await _apiService.removeDescartado(descartadoId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Eliminado de descartados")),
        );
        _refreshCandidatosFavoritos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar descartado: $e")),
      );
    }
  }

  Widget _buildCandidateCard({
    required Candidato candidato,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CandidateDetailScreen(
                candidatoId: candidato.id,
                controller: TCardController(),
              ),
            ),
          );
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: candidato.perfilePicture != null && candidato.perfilePicture!.isNotEmpty
              ? Image.network(
                  candidato.perfilePicture!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 60, color: Colors.grey);
                  },
                )
              : const Icon(Icons.person, size: 60, color: Colors.grey),
        ),
        title: Text(
          '${candidato.nombre} ${candidato.apellido}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Partido: ${candidato.partido}',
                style: const TextStyle(color: Colors.redAccent)),
            Text('Ciudad: ${candidato.ciudad}',
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureCandidatosFavoritos = _apiService.getFavoritos();
    _futureCandidatosDescartados = _apiService.getDescartados();
  }

  Future<void> _refreshCandidatosFavoritos() async {
    setState(() {
      _futureCandidatosFavoritos = _apiService.getFavoritos();
      _futureCandidatosDescartados = _apiService.getDescartados();
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
          } else {
            final favoritos = snapshot.data ?? [];
            return ListView(
              children: [
                if (favoritos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No tienes candidatos favoritos aún.')),
                  ),
                ...favoritos.map(
                  (favorito) => _buildCandidateCard(
                    candidato: favorito.candidatoData!,
                    onDelete: () => _removeFavorito(favorito.id),
                  ),
                ),
                ExpansionTile(
                  title: const Text('Candidatos descartados'),
                  initiallyExpanded: _descartadosExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _descartadosExpanded = expanded;
                    });
                  },
                  children: [
                    FutureBuilder<List<CandidatoDescartado>>(
                      future: _futureCandidatosDescartados,
                      builder: (context, descartadosSnapshot) {
                        if (descartadosSnapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          );
                        } else if (descartadosSnapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Error: ${descartadosSnapshot.error}'),
                          );
                        } else {
                          final descartados = descartadosSnapshot.data ?? [];
                          if (descartados.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No has descartado candidatos.'),
                            );
                          }
                          return Column(
                            children: descartados
                                .map(
                                  (descartado) => _buildCandidateCard(
                                    candidato: descartado.candidatoData!,
                                    onDelete: () => _removeDescartado(descartado.id),
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}