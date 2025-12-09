import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/users/presentation/widgets/roles_selector_sheet.dart';
import 'package:phone_management_system_admin/features/users/presentation/widgets/user_role_chip.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class UserRolesSection extends StatelessWidget {
  final UserModel user;

  const UserRolesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                text: "Roles",
                style: appStyle(14, AppColors.kDark, FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => RoleSelectorSheet(user: user),
                  );
                },
                child: Text(
                  "Edit",
                  style: appStyle(12, AppColors.kPrimary, FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: user.roles.map((r) => UserRoleChip(role: r)).toList(),
          ),
        ],
      ),
    );
  }
}
