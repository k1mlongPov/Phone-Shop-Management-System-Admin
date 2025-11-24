import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AppSnackbar {
  // Success Snackbar
  static void success({
    required String title,
    required String message,
    int duration = 2,
  }) {
    Get.snackbar(
      title,
      message,
      messageText: ReusableText(
        text: message,
        style: appStyle(14, AppColors.kWhite, FontWeight.normal),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: duration),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Error Snackbar
  static void error({
    required String title,
    required String message,
    int duration = 2,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(seconds: duration),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
