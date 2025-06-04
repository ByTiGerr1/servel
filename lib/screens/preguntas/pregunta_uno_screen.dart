import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/widgets/birth_date_picker_state.dart';
import 'package:servel/widgets/red_button.dart';
import 'package:servel/widgets/secondary_button.dart';
import 'package:servel/widgets/widget_progress.dart';

class PreguntaUnoScreen extends StatefulWidget {
  const PreguntaUnoScreen({super.key});

  @override
  State<PreguntaUnoScreen> createState() => _PreguntaUnoScreenState();
}

class _PreguntaUnoScreenState extends State<PreguntaUnoScreen> {
  String _generoEscogido = '';
  bool _abierto= false;
  final List<String> _opciones = ['Femenino', 'Masculino', 'No binarie'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8), // Ajusta la separación
              buildProgressRow(total: 4, activeIndex: 0)
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
              width: double.infinity, 
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Text("¡Cuentanos sobre ti!", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
                ),
                ),
              ),
              Container(
                width: double.infinity, 
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), 
                child: Text("¿Cúal es tu género?", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ), 
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _abierto = !_abierto;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(_generoEscogido.isEmpty ? "Seleccione una opcion" : "$_generoEscogido"),
                        );
                      }, 
                      body:
                      Column(
                        children: _opciones.map((opcion) {
                          return ListTile(
                            title: Text(opcion),
                            onTap: () {
                              setState(() {
                                _generoEscogido = opcion;
                                _abierto = false; // ✅ Cierra el panel al seleccionar
                              });
                            },
                          );
                        }).toList(),
                      ),
                      isExpanded: _abierto,
                      canTapOnHeader: true,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity, 
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), 
                child: Text("Cuando naciste?", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ), 
              ),
              Container(
                width: double.infinity, 
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: BirthDatePicker(),
              ),


              //Botones
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: RedButton(text: "Siguiente", 
                onPressed: () {
                  Navigator.pushNamed(context, 
                  '/preguntaDos');
                },),
              ),
              SecondaryTextButton(text: "Atras", onPressed: () {
                Navigator.pop(context);
              },),
            
            ],
          ),
        ),
      );
  }
}