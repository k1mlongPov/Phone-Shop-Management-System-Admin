import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/presentation/controllers/bottom_nav_controller.dart';
import 'package:phone_management_system_admin/core/presentation/pages/bottom_nav_page.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavController(), permanent: true);
    return const BottomNavPage();
  }
}
