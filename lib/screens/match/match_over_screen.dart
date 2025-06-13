import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/widgets/red_button.dart';
import 'package:servel/widgets/secondary_button.dart';
import 'package:servel/widgets/widget_progress.dart';

class MatchOverScreen extends StatelessWidget {
  const MatchOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Conoce tu voto",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150.sp),
              child: Text("Esos fueron los candidatos recomendados!",
              style: TextStyle(fontSize: 34.sp, 
              fontWeight: FontWeight.bold,
              color: Colors.red),
              textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Puedes seguir mirando candidatos o pasar a tu feed",
                style: TextStyle(fontSize: 14.sp, 
                fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 200.sp, 0, 8.sp),
              child: RedButton(text: "Feed", 
              onPressed: () {
                Navigator.pushNamed(context, '/home');
                },
                ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SecondaryTextButton(text: "Seguir", onPressed: () {
                  Navigator.pushReplacementNamed(context, '/matchLaunch');
                  },),
              ),
            
          ], 
        ),
      ),
    );
  }
}