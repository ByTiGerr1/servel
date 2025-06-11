import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ValidacionCodigoNumeroScreen extends StatefulWidget {
  const ValidacionCodigoNumeroScreen({super.key});

  @override
  State<ValidacionCodigoNumeroScreen> createState() => _ValidacionCodigoNumeroScreenState();
}

class _ValidacionCodigoNumeroScreenState extends State<ValidacionCodigoNumeroScreen> {
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verificación")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ingresa el código de 6 dígitos"),
            const SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: pinController,
              onChanged: (value) {
                print("Código ingresado: $value");
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Código completo: ${pinController.text}");
              },
              child: const Text("Verificar"),
            ),
          ],
        ),
      ),
    );
  }
}
