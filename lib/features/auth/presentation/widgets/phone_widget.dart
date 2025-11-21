import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_button.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PhoneWidget extends StatelessWidget {
  PhoneWidget({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    final phoneOnly = v.replaceAll(RegExp(r'\D'), '');
    if (phoneOnly.length < 8) return 'Enter a valid phone number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Form(
        key: _formKey, // optional phone-specific form key in your controller
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: 'Sign in with your phone number',
              style: appStyle(14, AppColors.kDark, FontWeight.normal),
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: auth.phone, // add this controller in AuthController
              keyboardType: TextInputType.phone,
              hintText: 'Phone number',
              prefixIcon: Icon(
                Icons.phone_android_rounded,
                color: AppColors.kGray,
                size: 18.sp,
              ),
              validator: _phoneValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 20.h),
            Obx(() {
              return CustomButton(
                text: auth.isLoading.value
                    ? 'Sending...'
                    : 'Get verification code',
                btnHeight: 40.h,
                radius: 20.r,
                onTap: auth.isLoading.value
                    ? null
                    : () async {
                        // validate then call controller method
                        final isValid =
                            _formKey.currentState?.validate() ?? true;
                        if (!isValid) return;

                        //final phone = auth.phone.text.trim();

                        try {
                          // Option A: trigger backend to send OTP then navigate to verification page
                          // await auth.requestPhoneOtp(phone);
                          // Get.to(() => VerificationPage(phone: phone));

                          // Option B: directly call verifyPhone (if your backend immediately verifies)
                          //await auth.verifyPhone(phone);
                        } catch (e) {
                          Get.snackbar('Error', e.toString(),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
              );
            }),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: AppSize.width * 0.35,
                    height: 1.h,
                    color: AppColors.kDark),
                ReusableText(
                    text: 'OR',
                    style: appStyle(14, AppColors.kDark, FontWeight.normal)),
                Container(
                    width: AppSize.width * 0.35,
                    height: 1.h,
                    color: AppColors.kDark),
              ],
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Sign in with Google',
              btnHeight: 40.h,
              btnBorderWidth: 1,
              btnColor: AppColors.kWhite,
              textColor: AppColors.kDark,
              hasIcon: true,
              imagePath: 'assets/icons/google.png',
              onTap: () {
                // TODO: social login
              },
            ),
          ],
        ),
      ),
    );
  }
}
