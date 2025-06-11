import 'package:flutter/material.dart';

class EnvioCodigoRegistro extends StatelessWidget {
  const EnvioCodigoRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OLA AVISAR SI ME VES'),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24.0)),
      )


    );
  }
}
