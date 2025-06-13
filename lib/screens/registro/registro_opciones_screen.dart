import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/screens/auth/login_screen.dart';
import 'package:servel/screens/auth/register_screen.dart';



class RegistroOpcionesScreen extends StatefulWidget {
  const RegistroOpcionesScreen({super.key});

  @override
  State<RegistroOpcionesScreen> createState() => _RegistroOpcionesScreenState();
}

class _RegistroOpcionesScreenState extends State<RegistroOpcionesScreen> {
  final List<Map<String, String>> comentarios = [
    {
      "usuario": "Juan Pérez",
      "comentario": "Me encanta la app, muy util y sencilla de usar.",
      "avatar": "https://i.pravatar.cc/150?img=1"
    },
    {
      "usuario": "Ana Gómez",
      "comentario": "Me encanta la app, muy util y sencilla de usar.",
      "avatar": "https://i.pravatar.cc/150?img=2"
    },
    {
      "usuario": "Carlos Ruiz",
      "comentario": "Me encanta la app, muy util y sencilla de usar.",
      "avatar": "https://i.pravatar.cc/150?img=3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        automaticallyImplyLeading: false,
        toolbarHeight: 110.h,
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
            height: 60.h,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0.h),
          child: Container(
            color: const Color.fromARGB(255, 156, 152, 152),
            height: 1.0.h,
          ),
        ),
      ),
      body: SingleChildScrollView(  
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final comentario = comentarios[index];
                    return Container(
                      width: 300.w,
                      margin: EdgeInsets.only(
                          left: 16.w,
                          right: index == comentarios.length - 1 ? 16.w : 0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(comentario["avatar"]!),
                                    radius: 25.r,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      comentario["usuario"]!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Expanded(
                                child: Text(
                                  comentario["comentario"]!,
                                  style: TextStyle(fontSize: 16.sp),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.h),
                child: Text(
                  "Únete",
                  style:
                      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
              ),



              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata_rounded),
                  label: Text("Regístrate",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xffFFFFFF),
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata_rounded),
                  label: Text("Inicia Sesion",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xffFFFFFF),
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Text(
                      "Al registrarse o iniciar sesión, aceptas nuestras",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: Text(
                        "Condiciones de uso y Políticas de privacidad",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
