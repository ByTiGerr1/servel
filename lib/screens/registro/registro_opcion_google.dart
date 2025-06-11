import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistroOpcionGoogle extends StatefulWidget {
  const RegistroOpcionGoogle({super.key});

  @override
  State<RegistroOpcionGoogle> createState() => _RegistroOpcionGoogleState();
}

class _RegistroOpcionGoogleState extends State<RegistroOpcionGoogle> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text("Google"),
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        toolbarHeight: 110.h,
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Image.asset("assets/logo.png", 
          fit: BoxFit.contain,
          height: 60.h,
          ),
        ),
        bottom: PreferredSize(preferredSize: Size.fromHeight(1.0.h), child: 
        Container(
          color: const Color.fromARGB(255, 156, 152, 152),
          height: 1.0.h,
        ),
        ),
      ),
      
    );  }
}