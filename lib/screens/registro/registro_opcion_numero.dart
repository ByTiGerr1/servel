import 'package:flutter/material.dart';
import 'package:servel/widgets/phone_numer_field.dart';
import 'package:servel/screens/auth/login_screen.dart';
import 'package:servel/screens/registro/validacion_codigo_numero_screen.dart';

class RegistroOpcionNumero extends StatefulWidget {
  const RegistroOpcionNumero({super.key});

  @override
  State<RegistroOpcionNumero> createState() => _RegistroOpcionNumeroState();
}

class _RegistroOpcionNumeroState extends State<RegistroOpcionNumero> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '56';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        title: Text("Número"),
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        toolbarHeight: 110,
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Image.asset("assets/logo.png", 
          fit: BoxFit.contain,
          height: 60,
          ),
        ),
        bottom: PreferredSize(preferredSize: Size.fromHeight(1.0), child: 
        Container(
          color: const Color.fromARGB(255, 156, 152, 152),
          height: 1.0,
        ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Ingresa tu numero de telefono", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Es posible que guardemos y enviemos un codigo de ",)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("verificacion a este número de teléfono",)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: PhoneNumberField(onCountryChanged: (code) {
                  setState(() {
                    _countryCode = code;
                  });
                },
                phoneController: _phoneController,
              ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿Ya tienes cuenta? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Inicia sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Center(
                child: 
                  ElevatedButton(onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ValidacionCodigoNumeroScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe2000d),
                    foregroundColor: Color(0xffFFFFFF),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 105),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    textStyle: TextStyle(
                      fontSize: 30,
                    )
                  )
                  , child: Text("Registrarme"))
              ),
            ),
        ],
        
      ),
    );
  }
}