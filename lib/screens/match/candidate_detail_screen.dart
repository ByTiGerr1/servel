// lib/screens/candidate_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:servel/models/candidato_model.dart';
import 'package:servel/services/candidate_service.dart';

class CandidateDetailScreen extends StatefulWidget {
  final int candidatoId;

  const CandidateDetailScreen({super.key, required this.candidatoId});

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  late Future<Candidato> _candidatoDetailFuture;
  final CandidateService _candidateService = CandidateService(); // Instancia de tu servicio

  bool _isFavorited = false; // Estado local para favorito
  bool _isDiscarded = false; // Estado local para descartado
  // IDs de favorito/descartado para poder eliminarlos
  int? _favoritoId;
  int? _descartadoId;

  @override
  void initState() {
    super.initState();
    _fetchCandidateDetailsAndStatus();
  }

  Future<void> _fetchCandidateDetailsAndStatus() async {
    setState(() {
      _candidatoDetailFuture = _candidateService.getCandidatoDetail(widget.candidatoId);
    });

    // Obtener el estado actual de favorito/descartado
    try {
      final favoritos = await _candidateService.getFavoritos();
      final descartados = await _candidateService.getDescartados();

      final favorito = favoritos.firstWhere(
        (fav) => fav.candidatoId == widget.candidatoId,
        orElse: () => CandidatoFavorito(id: -1, candidatoId: -1, fechaAgregado: DateTime.now()), // Sentinel value
      );
      final descartado = descartados.firstWhere(
        (disc) => disc.candidatoId == widget.candidatoId,
        orElse: () => CandidatoDescartado(id: -1, candidatoId: -1, fechaDescartado: DateTime.now()), // Sentinel value
      );

      setState(() {
        _isFavorited = favorito.id != -1;
        _favoritoId = _isFavorited ? favorito.id : null;

        _isDiscarded = descartado.id != -1;
        _descartadoId = _isDiscarded ? descartado.id : null;
      });
    } catch (e) {
      // Manejar el error de carga de favoritos/descartados
      _showSnackBar('Error al cargar estado de favorito/descartado: $e', Colors.red);
    }
  }

  void _toggleFavorite() async {
    try {
      if (_isFavorited) {
        // Si ya es favorito, lo removemos
        if (_favoritoId != null) {
          await _candidateService.removeFavorito(_favoritoId!);
          setState(() {
            _isFavorited = false;
            _favoritoId = null;
          });
          _showSnackBar('Candidato eliminado de favoritos.', Colors.orange);
        }
      } else {
        // Si no es favorito, lo agregamos
        await _candidateService.addFavorito(widget.candidatoId);
        // Volvemos a obtener el ID del favorito recién creado
        await _fetchCandidateDetailsAndStatus(); // Refresca para obtener el nuevo _favoritoId
        setState(() {
          _isFavorited = true; // No es estrictamente necesario, _fetchCandidateDetailsAndStatus lo hará
        });
        _showSnackBar('Candidato agregado a favoritos.', Colors.green);

        // Si estaba descartado, lo quitamos de descartados
        if (_isDiscarded && _descartadoId != null) {
          await _candidateService.removeDescartado(_descartadoId!);
          setState(() {
            _isDiscarded = false;
            _descartadoId = null;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Error al procesar favorito: $e', Colors.red);
    }
  }

  void _toggleDiscarded() async {
    try {
      if (_isDiscarded) {
        // Si ya está descartado, lo removemos
        if (_descartadoId != null) {
          await _candidateService.removeDescartado(_descartadoId!);
          setState(() {
            _isDiscarded = false;
            _descartadoId = null;
          });
          _showSnackBar('Candidato eliminado de descartados.', Colors.orange);
        }
      } else {
        // Si no está descartado, lo agregamos
        await _candidateService.addDescartado(widget.candidatoId);
        // Volvemos a obtener el ID del descartado recién creado
        await _fetchCandidateDetailsAndStatus(); // Refresca para obtener el nuevo _descartadoId
        setState(() {
          _isDiscarded = true; // No es estrictamente necesario, _fetchCandidateDetailsAndStatus lo hará
        });
        _showSnackBar('Candidato agregado a descartados.', Colors.green);

        // Si estaba en favoritos, lo quitamos de favoritos
        if (_isFavorited && _favoritoId != null) {
          await _candidateService.removeFavorito(_favoritoId!);
          setState(() {
            _isFavorited = false;
            _favoritoId = null;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Error al procesar descartado: $e', Colors.red);
    }
  }

  void _submitFinalDecision(Candidato candidato) async {
    try {
      // Asume que la ID del tipo de elección presidencial es 1 (o la que uses)
      const int tipoEleccionPresidencialId = 1; // Ajusta esto a la ID real de tu tipo de elección presidencial

      await _candidateService.submitDecisionFinal(candidato.id, tipoEleccionPresidencialId);
      _showSnackBar('¡Decisión final registrada para ${candidato.nombre}!', Colors.blue);
      // Opcional: Navegar a una pantalla de confirmación o volver atrás
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Error al registrar decisión final: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Candidato'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Candidato>(
        future: _candidatoDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al cargar detalles del candidato: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No se encontró información para este candidato.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final candidato = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.blueGrey[100],
                      backgroundImage: candidato.perfilePicture != null && candidato.perfilePicture!.isNotEmpty
                          ? NetworkImage(candidato.perfilePicture!)
                          : null,
                      child: candidato.perfilePicture == null || candidato.perfilePicture!.isEmpty
                          ? Icon(Icons.person, size: 80, color: Colors.blueGrey[700])
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${candidato.nombre} ${candidato.apellido}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    candidato.partido,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Biografía:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    candidato.bio ?? 'No se ha proporcionado una biografía.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Propuesta Electoral:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    candidato.propuestaElectoral,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleFavorite,
                        icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
                        label: Text(_isFavorited ? 'En Favoritos' : 'Añadir a Favoritos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFavorited ? Colors.redAccent : Colors.grey[300],
                          foregroundColor: _isFavorited ? Colors.white : Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _toggleDiscarded,
                        icon: Icon(_isDiscarded ? Icons.close : Icons.cancel_outlined),
                        label: Text(_isDiscarded ? 'Descartado' : 'Descartar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDiscarded ? Colors.deepOrangeAccent : Colors.grey[300],
                          foregroundColor: _isDiscarded ? Colors.white : Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _submitFinalDecision(candidato),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Color para la decisión final
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(double.infinity, 50), // Ancho completo
                      ),
                      child: const Text('¡Este es mi Candidato Final!'),
                    ),
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