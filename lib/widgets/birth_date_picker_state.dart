import 'package:flutter/material.dart';

class BirthDatePicker extends StatefulWidget {
  @override
  _BirthDatePickerState createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  TextEditingController _controller = TextEditingController();

  // Función para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    // Mostrar el DatePicker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _controller.text = "${picked.toLocal()}".split(' ')[0]; // yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer( // Evita que se edite manualmente
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Seleccionar fecha',
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          readOnly: true, // Evita que se edite manualmente
        ),
      ),
    );
  }
}
