import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/core/theme/app_theme.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/splash_page.dart';
import 'core/bindings/initial_binding.dart';
import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      home: const AppInitializer(),
      getPages: AppPages.routes,
      theme: AppTheme.light,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 600),
    ),
  );
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      builder: (context, child) => const SplashPage(),
    );
  }
}
