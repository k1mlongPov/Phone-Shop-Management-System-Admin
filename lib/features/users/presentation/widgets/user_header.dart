import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class UserHeader extends StatelessWidget {
  final UserModel user;

  const UserHeader({super.key, required this.user});

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: (user.profile != null && user.profile!.isNotEmpty)
                ? NetworkImage(user.profile!)
                : const AssetImage("assets/images/default_user.png")
                    as ImageProvider,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: user.username,
                  style: appStyle(18, AppColors.kDark, FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                ReusableText(
                  text: user.email,
                  style: appStyle(13, Colors.grey.shade700, FontWeight.normal),
                ),
                SizedBox(height: 6.h),
                _statusBadge(user.isActive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool active) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            active ? Colors.green.withOpacity(.1) : Colors.red.withOpacity(.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ReusableText(
        text: active ? "Active" : "Inactive",
        style: appStyle(
          11,
          active ? Colors.green : Colors.red,
          FontWeight.w600,
        ),
      ),
    );
  }
}
