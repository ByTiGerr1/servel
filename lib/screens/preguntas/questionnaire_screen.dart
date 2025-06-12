import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/screens/match/match_onboarding_screen.dart';
import 'package:servel/models/questionn_models.dart';
import 'package:servel/services/questionnaire_service.dart'; 
import 'package:servel/widgets/red_button.dart';
import 'package:servel/widgets/secondary_button.dart';
import 'package:servel/widgets/widget_progress.dart';

class QuestionnaireScreen extends StatefulWidget {
  final int tipoEleccionId; 
  final String tipoEleccionNombre;

  const QuestionnaireScreen({
    super.key,
    required this.tipoEleccionId,
    required this.tipoEleccionNombre,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late Future<List<Pregunta>> _questionsFuture;
  final Map<int, int> _userSelections = {}; 
  int _currentQuestionIndex = 0;
  List<Pregunta> _allQuestions = []; 

  @override
  void initState() {
    super.initState();
    _questionsFuture = QuestionnaireService().getPendingQuestions(
      tipoEleccionId: widget.tipoEleccionId,
    );
    _questionsFuture.then((questions) {
      setState(() {
        _allQuestions = questions;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar preguntas: ${error.toString()}')),
      );
    });
  }

  void _onOptionSelected(int preguntaId, int opcionElegidaId) {
    setState(() {
      _userSelections[preguntaId] = opcionElegidaId;
    });
  }

  void _nextQuestion() {
    final currentQuestion = _allQuestions[_currentQuestionIndex];
    if (!_userSelections.containsKey(currentQuestion.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una opción antes de continuar.')),
      );
      return;
    }

    if (_currentQuestionIndex < _allQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitAnswers();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    } else {
      Navigator.pop(context); 
    }
  }

  Future<void> _submitAnswers() async {
    final List<UserAnswer> answers = _userSelections.entries
        .map((entry) => UserAnswer(
              preguntaID: entry.key,
              opcionElegidaID: entry.value,
            ))
        .toList();

    try {
      await QuestionnaireService().submitUserAnswers(answers);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuestas guardadas exitosamente!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MatchLaunchScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar respuestas: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.h,
        title: FutureBuilder<List<Pregunta>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  buildProgressRow(
                    total: _allQuestions.length, 
                    activeIndex: _currentQuestionIndex, 
                  ),
                ],
              );
            }
            return const SizedBox.shrink(); 
          },
        ),
      ),
      body: FutureBuilder<List<Pregunta>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, '/matchLaunch');
            });
            return const SizedBox.shrink();
          } else {
            final questions = snapshot.data!;
            if (questions.isEmpty) {
              return const Center(child: Text('No hay preguntas para mostrar.'));
            }
            final currentQuestion = questions[_currentQuestionIndex];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
                    child: Text(
                      currentQuestion.texto, 
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, 
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 20.h),
                    child: Text(
                      "Selecciona una opción", 
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w200),
                    ),
                  ),
                  ...currentQuestion.opcionesRespuesta.asMap().entries.map<Widget>((entry) {
                    OpcionRespuesta option = entry.value;
                    final bool isSelected = _userSelections[currentQuestion.id] == option.id;

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CheckboxListTile( 
                        contentPadding: EdgeInsets.all(20.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          side: const BorderSide(color: Color(0xfff3f4f6)),
                        ),
                        tileColor: const Color(0xfff3f4f6),
                        title: Text(option.texto),
                        selected: isSelected,
                        selectedTileColor: const Color(0xfffff0f0),
                        secondary: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
                          color: const Color(0xffe20612),
                        ),
                        value: isSelected, 
                        onChanged: (bool? newValue) {
                          _onOptionSelected(currentQuestion.id, option.id);
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 30.h), 
                  RedButton(
                    text: _currentQuestionIndex == questions.length - 1 ? "Finalizar" : "Siguiente",
                    onPressed: _nextQuestion,
                  ),
                  SizedBox(height: 10.h), 
                  SecondaryTextButton(
                    text: _currentQuestionIndex > 0 ? "Atrás" : "Salir",
                    onPressed: _previousQuestion,
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