import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;

  const UserInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _section(
      title: "User Information",
      children: [
        _infoRow("Email", user.email),
        _infoRow("Phone", user.phone ?? "—"),
        _infoRow("Verified", user.verification ? "Yes" : "No"),
      ],
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: title,
            style: appStyle(14, AppColors.kDark, FontWeight.bold),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: label,
            style: appStyle(12, Colors.grey.shade700, FontWeight.w600),
          ),
          ReusableText(
            text: value,
            style: appStyle(12, AppColors.kDark, FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
