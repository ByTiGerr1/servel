// lib/screens/match_results_screen.dart
import 'package:flutter/material.dart';
import 'package:servel/models/candidato_model.dart';
import 'package:servel/screens/match/candidate_detail_screen.dart';
import 'package:servel/services/candidate_service.dart';

class MatchResultScreen extends StatefulWidget {
  final int tipoEleccionId; // ID del tipo de elección (e.g., presidencial)
  const MatchResultScreen({super.key, required this.tipoEleccionId});

  @override
  State<MatchResultScreen> createState() => _MatchResultScreenState();
}

class _MatchResultScreenState extends State<MatchResultScreen> {
  late Future<List<MatchResult>> _matchResultsFuture;
  final CandidateService _candidateService = CandidateService();

  @override
  void initState() {
    super.initState();
    _fetchMatchResults();
  }

  void _fetchMatchResults() {
    setState(() {
      _matchResultsFuture = _candidateService.getMatchCandidatos(widget.tipoEleccionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match"),
      ),
      body: FutureBuilder<List<MatchResult>>(
        future: _matchResultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se cargan los datos, muestra un indicador de carga
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay un error, muestra un mensaje de error
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al cargar resultados: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Si no hay datos, o la lista está vacía
            return const Center(
              child: Text(
                'No se encontraron candidatos o resultados de coincidencia para esta elección.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            // Si los datos están disponibles, construye la lista
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final matchResult = snapshot.data![index];
                // Asegúrate de que 'candidato' no sea null antes de usarlo.
                // Si es null, podríamos mostrar un widget vacío o un error.
                if (matchResult.candidato == null) {
                  return const SizedBox.shrink(); // O un Text('Candidato no disponible')
                }

                // Ahora que hemos comprobado que 'candidato' no es null,
                // podemos usar '!' para acceder a sus propiedades de forma segura.
                // O seguir usando '?.'. El '!' es más conciso si ya se sabe que no es null.
                final candidato = matchResult.candidato!; // <-- Ahora sabemos que no es null

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    // Imagen del candidato (si está disponible)
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueGrey[100],
                      // Usar 'candidato.perfilePicture' directamente
                      // como 'candidato' ya no es null por la comprobación anterior.
                      // 'perfilePicture' sigue siendo nullable, así que usamos '?.isNotEmpty'
                      backgroundImage: candidato.perfilePicture != null && candidato.perfilePicture!.isNotEmpty
                          ? NetworkImage(candidato.perfilePicture!) // Usa NetworkImage para URLs
                          : null,
                      child: candidato.perfilePicture == null || candidato.perfilePicture!.isEmpty
                          ? Icon(Icons.person, size: 30, color: Colors.blueGrey[700])
                          : null,
                    ),
                    // Nombre y partido del candidato
                    title: Text(
                      // Acceso directo a nombre y apellido porque 'candidato' ya no es null
                      '${candidato.nombre} ${candidato.apellido}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Acceso directo a partido
                          candidato.partido,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        // Porcentaje de coincidencia
                        Text(
                          'Coincidencia: ${matchResult.matchPercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                    onTap: () {
                      // Navegar a la pantalla de detalle del candidato
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Acceso directo al ID del candidato
                          builder: (context) => CandidateDetailScreen(candidatoId: candidato.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}