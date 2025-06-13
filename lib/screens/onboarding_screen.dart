import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/screens/registro/registro_opciones_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "image": "assets/Icon_1.png",
      "text": "Conoce a los candidatos",
    },
    {
      "image": "assets/Icon_2.png",
      "text": "Consulta resultados en tiempo real",
    },
    {
      "image": "assets/Icon_3.png",
      "text": "Participa y haz oír tu voz",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      int page = _controller.page?.round() ?? 0;
      if (page != currentPage) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RegistroOpcionesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 500.h,
                      width: 370.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.red,
                        image: DecorationImage(
                          image: AssetImage(_slides[index]["image"]!),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      _slides[index]["text"]!,
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50.h),
                backgroundColor: Colors.red,
              ),
              onPressed: nextPage,
              child: Text(currentPage == _slides.length - 1
                  ? "Comenzar"
                  : "Siguiente", style: TextStyle(color: Colors.white),),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: SmoothPageIndicator(
              controller: _controller, 
              count: _slides.length,
              effect: WormEffect(
                activeDotColor: Colors.red,
                dotColor: Colors.grey,
                dotHeight: 12.h,
                dotWidth: 12.h,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}