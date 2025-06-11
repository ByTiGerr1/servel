import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(25.w, 0.h, 25.w, 10.h),
        textStyle: TextStyle(
          fontSize: 20.sp,
        ),
      ),
      child: Text(text),
    );
  }
}
