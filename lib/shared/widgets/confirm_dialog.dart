import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Future<bool> showConfirmDialog({
  required String title,
  required String message,
  String confirmText = "Yes",
  String cancelText = "Cancel",
  Color confirmColor = AppColors.kPrimary,
}) async {
  final result = await Get.dialog<bool>(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: title,
              style: appStyle(16, AppColors.kDark, FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              style: appStyle(13, Colors.grey.shade700, FontWeight.normal),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    cancelText,
                    style: appStyle(14, AppColors.kDark, FontWeight.w500),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => Get.back(result: true),
                  child: Text(
                    confirmText,
                    style: appStyle(14, AppColors.kWhite, FontWeight.w500),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );

  return result == true;
}
