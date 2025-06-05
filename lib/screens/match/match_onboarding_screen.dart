import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/screens/match/match_results_screen.dart';
import 'package:servel/widgets/red_button.dart';
import 'package:servel/widgets/secondary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchLaunchScreen extends StatelessWidget {
  const MatchLaunchScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Tenemos candidatos que podrian interesarte!",
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xffe2000d),
              ),
              textAlign: TextAlign.center,
            ),
            // Imágenes
            Container(
              padding: EdgeInsets.only(top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageCard('assets/Boric.jpg'),
                  _buildImageCard('assets/Michelle.jpg'),
                ],
              ),
            ),
            
            // Botón "Haz match"
            Padding(
                padding: EdgeInsets.only(top: 45.h),
                child: RedButton(text: "Haz Match", 
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token = prefs.getString('auth_token');

                  if (token != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchResultScreen(tipoEleccionId: 1),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Debes iniciar sesión')),
                    );
                  }
                }
,),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: SecondaryTextButton(text: "Todavia no", onPressed: () {
                  Navigator.pop(context);
                },),
              ),
          ],
        ),
      ),
    );
  }

  // 🔧 Función para construir imagen con estilo
  Widget _buildImageCard(String imagePath) {
    return Container(
      width: 150.w,
      height: 220.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
