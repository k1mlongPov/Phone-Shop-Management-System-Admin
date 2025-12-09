import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PersonTile extends StatelessWidget {
  final String name;
  final String? phone;
  final String email;
  final List roles;
  final VoidCallback onTap;

  const PersonTile({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.roles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.kPrimary.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.kPrimary, size: 22.r),
            ),
            SizedBox(width: 12.w),

            /// Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: name,
                    style: appStyle(14, AppColors.kDark, FontWeight.w600),
                  ),

                  if (phone != null && phone!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: "📞 $phone",
                      style:
                          appStyle(12, Colors.grey.shade700, FontWeight.normal),
                    ),
                  ],

                  if (email.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    ReusableText(
                      text: "✉️ $email",
                      style:
                          appStyle(12, Colors.grey.shade700, FontWeight.normal),
                    ),
                  ],

                  /// Role badges for staff/admins
                  if (roles.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      children: roles
                          .map((r) => RoleBadge(role: r.toString()))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ReusableText(
        text: role,
        style: appStyle(10, AppColors.kPrimary, FontWeight.w600),
      ),
    );
  }
}
