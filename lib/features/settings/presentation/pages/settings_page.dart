import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController =
        Get.put(AuthController(repository: Get.find(), storage: Get.find()));
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            authController.logout();
          },
          child: const Icon(Icons.logout_rounded),
        ),
      ),
    );
  }
}
