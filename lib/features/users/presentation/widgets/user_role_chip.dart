import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class UserRoleChip extends StatelessWidget {
  final String role;

  const UserRoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.kPrimary;
    if (role == "Admin") color = Colors.red;
    if (role == "Staff") color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ReusableText(
        text: role,
        style: appStyle(11, color, FontWeight.w600),
      ),
    );
  }
}
