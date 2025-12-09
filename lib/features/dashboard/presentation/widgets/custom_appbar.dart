import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, required this.user});

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSize.width,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        color: AppColors.kPrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundImage: NetworkImage('${user.profile}'),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: '${getTimeOfDay()}! Admin ${user.username}',
                        style: appStyle(16, AppColors.kWhite, FontWeight.w600),
                      ),
                      ReusableText(
                        text: 'Welcome Back',
                        style: appStyle(12, AppColors.kWhite.withOpacity(.8),
                            FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.notifications,
              color: AppColors.kSecondary,
            )
          ],
        ),
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 16) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
