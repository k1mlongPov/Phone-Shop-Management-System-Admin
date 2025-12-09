import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/users/logic/user_controller.dart';
import 'package:phone_management_system_admin/features/users/presentation/widgets/user_role_section.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

import 'package:phone_management_system_admin/features/users/domains/user_model.dart';

import 'package:phone_management_system_admin/features/users/presentation/widgets/user_header.dart';
import 'package:phone_management_system_admin/features/users/presentation/widgets/user_info_section.dart';
import 'package:phone_management_system_admin/features/users/presentation/widgets/user_activity_section.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user; // initial snapshot of passed user
  final UsersController _ctrl = Get.find<UsersController>();

  UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        elevation: 0,
        title: ReusableText(
          text: "User Details",
          style: appStyle(16, AppColors.kDark, FontWeight.w600),
        ),
      ),
      body: Obx(() {
        /// get newest version after updates
        final latest = _ctrl.findUserById(user.id) ?? user;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserHeader(user: latest),
              SizedBox(height: 20.h),
              UserInfoSection(user: latest),
              SizedBox(height: 20.h),
              UserRolesSection(user: latest),
              SizedBox(height: 20.h),
              UserActivitySection(user: latest),
            ],
          ),
        );
      }),
    );
  }
}
