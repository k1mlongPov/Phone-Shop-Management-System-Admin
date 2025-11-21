import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/auth/presentation/widgets/login_widget.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 125.h,
              child: const Image(
                image: AssetImage(
                  'assets/images/Vetheary-logo.png',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25.w, bottom: 20.w),
              child: ReusableText(
                text: 'Welcome back!',
                style: appStyle(24, AppColors.kWhite, FontWeight.w600),
              ),
            ),
            const LoginWidget(),
          ],
        ),
      ),
    );
  }
}
