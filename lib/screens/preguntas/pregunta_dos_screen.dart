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


class PreguntaDosScreen extends StatefulWidget {
  const PreguntaDosScreen({super.key});

  @override
  State<PreguntaDosScreen> createState() => _PreguntaDosScreenState();
}

class _PreguntaDosScreenState extends State<PreguntaDosScreen> {
  List<CheckboxItem> items = [
  CheckboxItem(title: "Economía", value: false, icon: Icons.payment),
  CheckboxItem(title: "Medio Amiente", value: false, icon: Icons.health_and_safety),
  CheckboxItem(title: "Salud", value: false, icon: Icons.school),
  CheckboxItem(title: "Seguridad", value: false, icon: Icons.school),
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
              SizedBox(height: 8.h), // Ajusta la separación
              buildProgressRow(total: 4, activeIndex: 1)
            ],
          ),
        ),
        body: SingleChildScrollView(
  child: Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
        child: Text(
          "¿Cuales son tus principales preocupaciones? 🎯",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 20.h),
        child: Text(
          "Selecciona una o mas ",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w200),
        ),
      ),
      
      ...items.asMap().entries.map<Widget>((entry) {
        int idx = entry.key;
        CheckboxItem item = entry.value;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.all(20.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
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
          Navigator.pushNamed(context, '/preguntaTres');
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