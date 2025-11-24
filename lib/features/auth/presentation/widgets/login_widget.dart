import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/auth/logic/switch_controller.dart';
import 'package:phone_management_system_admin/features/auth/presentation/widgets/email_phone_switch.dart';
import 'package:phone_management_system_admin/features/auth/presentation/widgets/email_widget.dart';
import 'package:phone_management_system_admin/features/auth/presentation/widgets/phone_widget.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final switchController = Get.find<SwitchController>();
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
          padding: EdgeInsets.fromLTRB(30.w, 12.h, 30.w, 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ReusableText(
                    text: 'Login',
                    style: appStyle(22, AppColors.kDark, FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                EmailPhoneSwitch(),
                Obx(
                  () {
                    return switchController.isSwitch.value
                        ? const EmailWidget()
                        : PhoneWidget();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
