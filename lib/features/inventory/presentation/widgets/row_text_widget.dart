import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget rowText(String key, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        SizedBox(
          width: 20.w,
          child: ReusableText(
            text: '-',
            style: appStyle(14, AppColors.kDark, FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 100.w,
          child: ReusableText(
            text: key,
            style: appStyle(14, AppColors.kDark, FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 20.w,
          child: ReusableText(
            text: ':',
            style: appStyle(14, AppColors.kDark, FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 180.w,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ReusableText(
              text: value,
              style: appStyle(14, AppColors.kDark, FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
