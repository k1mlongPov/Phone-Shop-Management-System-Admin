import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await auth.bootstrap().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return;
        },
      );
    } catch (e, st) {
      Get.snackbar('SplashGate ERROR:', '$e\n$st');
    }

    final tok = auth.token.value;

    if (tok != null && tok.isNotEmpty) {
      Get.offAllNamed(Routes.APPSHELL);
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
