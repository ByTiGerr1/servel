import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffe2000d),
        foregroundColor: const Color(0xffFFFFFF),
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 105.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 2.h,
        textStyle: TextStyle(fontSize: 25.sp),
      ),
      child: Text(text),
    );
  }
}
