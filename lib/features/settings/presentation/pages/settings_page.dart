import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/users/presentation/pages/user_detail_page.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/widgets/confirm_dialog.dart';

import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  UserModel? fetchCurrentUser() {
    final authController = Get.find<AuthController>();
    return authController.user.value;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Don't create controller here
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: ReusableText(
          text: "Settings",
          style: appStyle(16, AppColors.kWhite, FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(12.r),
        children: [
          _SectionCard(
            title: "Account",
            children: [
              _SettingTile(
                icon: Icons.person_outline,
                title: "My profile",
                subtitle: "View account info",
                onTap: () {
                  Get.to(() => UserDetailPage(user: fetchCurrentUser()!));
                },
              ),
              _SettingTile(
                icon: Icons.lock_outline,
                title: "Change password",
                subtitle: "Update your password",
                onTap: () {
                  Get.snackbar("Info", "Change password page not added yet");
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),

          _SectionCard(
            title: "Inventory",
            children: [
              _SettingTile(
                icon: Icons.category_outlined,
                title: "Manage categories",
                subtitle: "Categories & subcategories",
                onTap: () {
                  // TODO: route to your Categories page
                  Get.snackbar("Info", "Categories page not linked yet");
                },
              ),
              _SettingTile(
                icon: Icons.store_outlined,
                title: "Manage suppliers",
                subtitle: "Supplier list & restock",
                onTap: () {
                  // TODO: route to SupplierPage
                  Get.snackbar("Info", "Suppliers page not linked yet");
                },
              ),
              _SettingTile(
                icon: Icons.sync,
                title: "Sync / Refresh data",
                subtitle: "Reload phones, accessories, categories, suppliers",
                onTap: () async {
                  // TODO: call your controllers fetch here
                  Get.snackbar("Sync", "Refresh logic not added yet");
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),

          _SectionCard(
            title: "App",
            children: [
              _SettingTile(
                icon: Icons.info_outline,
                title: "About",
                subtitle: "Version & build info",
                onTap: () {
                  Get.snackbar("About", "Phone Management System Admin");
                },
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // LOGOUT
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.logout_rounded, color: Colors.red),
                SizedBox(width: 10.w),
                Expanded(
                  child: ReusableText(
                    text: "Logout",
                    style: appStyle(14, AppColors.kDark, FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () async {
                    final yes = await showConfirmDialog(
                      title: "Logout",
                      message: "Are you sure you want to logout?",
                      confirmText: "Logout",
                      confirmColor: Colors.red,
                    );
                    if (yes) {
                      authController.logout();
                    }
                  },
                  child: Text(
                    "Logout",
                    style: appStyle(12, AppColors.kWhite, FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- UI HELPERS --------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: title,
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          ...children,
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kPrimary),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: appStyle(13, AppColors.kDark, FontWeight.w600)),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style:
                          appStyle(11, Colors.grey.shade600, FontWeight.normal),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
