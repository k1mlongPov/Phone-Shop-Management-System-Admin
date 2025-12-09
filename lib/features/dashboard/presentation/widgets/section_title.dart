import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: AppColors.kPrimary.withOpacity(0.08),
            child: Icon(icon, size: 16.r, color: AppColors.kPrimary),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: title,
                  style: appStyle(14, AppColors.kDark, FontWeight.w700),
                ),
                if (subtitle != null)
                  ReusableText(
                    text: subtitle!,
                    style: appStyle(
                      11,
                      Colors.grey.shade600,
                      FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
