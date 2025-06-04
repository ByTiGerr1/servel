import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/widgets/red_button.dart';
import 'package:servel/widgets/secondary_button.dart';
import 'package:servel/widgets/widget_progress.dart';

class CheckboxItem {
  String title;
  bool value;
  IconData icon;

  CheckboxItem({required this.title, required this.value, required this.icon});
}

class PreguntaCuatroScreen extends StatefulWidget {
  const PreguntaCuatroScreen({super.key});

  @override
  State<PreguntaCuatroScreen> createState() => _PreguntaCuatroScreenState();
}

class _PreguntaCuatroScreenState extends State<PreguntaCuatroScreen> {
  List<CheckboxItem> items = [
    CheckboxItem(title: "Reducir impuestos", value: false, icon: Icons.trending_down),
    CheckboxItem(title: "Mejorar la educación pública", value: false, icon: Icons.school),
    CheckboxItem(title: "Impulsar la economía local", value: false, icon: Icons.currency_exchange),
    CheckboxItem(title: "Combatir la corrupción", value: false, icon: Icons.group),
    CheckboxItem(title: "Asegurar un sistema de salud accesible", value: false, icon: Icons.healing),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            buildProgressRow(total: 4, activeIndex: 3)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: Text(
                "Prioridades Gubernamentales",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text(
                "Selecciona una o mas ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
              ),
            ),

            // CheckboxListTiles generados dinámicamente
            ...items.asMap().entries.map<Widget>((entry) {
              int idx = entry.key;
              CheckboxItem item = entry.value;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Color(0xfff3f4f6)),
                  ),
                  tileColor: Color(0xfff3f4f6),
                  title: Text(item.title),
                  selected: item.value,
                  selectedTileColor: Color(0xfffff0f0),
                  secondary: Icon(item.icon, color: Color(0xffe20612)),
                  value: item.value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      items[idx].value = newValue ?? false;
                    });
                  },
                ),
              );
            }),

            RedButton(
              text: "Siguiente",
              onPressed: () {
                Navigator.pushNamed(context, '/matchLaunch');
              },
            ),
            SecondaryTextButton(
              text: "Atrás",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
