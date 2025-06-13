import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildProgressRow({
  required int total,
  required int activeIndex,
  Color color = Colors.red,
  double height = 6,
  double borderRadius = 3,
  double spacing = 10,
}) {
  List<Widget> children = [];

  for (int i = 0; i < total; i++) {
    children.add(
      Expanded(
        child: Container(
          height: height.h,
          decoration: BoxDecoration(
            color: i == activeIndex ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
      ),
    );

    if (i < total - 1) {
      children.add(SizedBox(width: spacing.w));
    }
  }

  return SizedBox(
    width: double.infinity,
    child: Row(children: children),
  );
}
