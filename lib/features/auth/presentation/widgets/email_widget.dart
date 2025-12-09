import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_button.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class EmailWidget extends StatefulWidget {
  const EmailWidget({super.key});

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? v) {
    return Get.find<AuthController>().validateEmail(v);
  }

  String? _passwordValidator(String? v) {
    return Get.find<AuthController>().validatePassword(v);
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSize.width,
              child: Center(
                child: ReusableText(
                  text: 'Sign in with your email and password',
                  style: appStyle(14, AppColors.kDark, FontWeight.normal),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: auth.email,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.kGray,
                size: 18.sp,
              ),
              validator: _emailValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 10.h),
            Obx(
              () => CustomTextField(
                controller: auth.password,
                hintText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.kGray,
                  size: 18.sp,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => auth.togglePasswordVisibility(),
                  child: auth.obscurePassword.value
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.kGray,
                          size: 18.sp,
                        )
                      : Icon(
                          Icons.remove_red_eye_outlined,
                          color: AppColors.kGray,
                          size: 18.sp,
                        ),
                ),
                validator: _passwordValidator,
                obscureText: auth.obscurePassword.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                child: ReusableText(
                  text: 'Forgot password?',
                  textAlign: TextAlign.end,
                  style: appStyle(
                    14,
                    AppColors.kPrimary.withOpacity(0.8),
                    FontWeight.normal,
                  ),
                ),
                onTap: () {},
              ),
            ),
            SizedBox(height: 10.h),
            Obx(() {
              return CustomButton(
                text: auth.isLoading.value ? 'Signing in...' : 'Sign in',
                btnHeight: 40.h,
                radius: 20.r,
                onTap: auth.isLoading.value
                    ? null
                    : () {
                        // validate form then call controller
                        if (_formKey.currentState?.validate() ?? false) {
                          auth.login();
                        }
                      },
              );
            }),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
