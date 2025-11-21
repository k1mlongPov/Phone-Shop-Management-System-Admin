import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_button.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _usernameValidator(String? v) {
    return Get.find<AuthController>().validateUsername(v);
  }

  String? _emailValidator(String? v) {
    return Get.find<AuthController>().validateEmail(v);
  }

  String? _passwordValidator(String? v) {
    return Get.find<AuthController>().validatePassword(v);
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30.r),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back_sharp,
                          size: 20.r,
                        ),
                        onTap: () {
                          Get.back();
                          auth.clearRegisterFields();
                        },
                      ),
                      SizedBox(width: 5.w),
                      ReusableText(
                        text: 'Back to login',
                        style: appStyle(14, AppColors.kDark, FontWeight.normal),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ReusableText(
                    text: 'Register',
                    style: appStyle(22, AppColors.kDark, FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  ReusableText(
                    text: 'Sign up with your email address',
                    style: appStyle(14, AppColors.kDark, FontWeight.normal),
                  ),
                  SizedBox(height: 10.h),

                  // Username
                  CustomTextField(
                    controller: auth.username,
                    hintText: 'Username',
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    validator: _usernameValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 10.h),

                  // Email
                  CustomTextField(
                    controller: auth.email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    validator: _emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 10.h),

                  // Password
                  CustomTextField(
                    controller: auth.password,
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    validator: _passwordValidator,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 10.h),

                  // Confirm password
                  CustomTextField(
                    controller: auth.confirmPassword,
                    hintText: 'Confirm password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColors.kGray,
                      size: 18.sp,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (v != auth.password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 20.h),

                  Obx(
                    () {
                      return CustomButton(
                        text:
                            auth.isLoading.value ? 'Signing up...' : 'Sign up',
                        btnHeight: 40.h,
                        radius: 20.r,
                        onTap: auth.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  auth.register();
                                }
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
