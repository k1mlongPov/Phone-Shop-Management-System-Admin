import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/users/logic/user_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

class RoleSelectorSheet extends StatefulWidget {
  final UserModel user;

  const RoleSelectorSheet({super.key, required this.user});

  @override
  State<RoleSelectorSheet> createState() => _RoleSelectorSheetState();
}

class _RoleSelectorSheetState extends State<RoleSelectorSheet> {
  final List<String> allRoles = ["Admin", "Staff", "Customer"];

  late String selectedRole; // SINGLE ROLE
  final UsersController c = Get.find<UsersController>();

  @override
  void initState() {
    selectedRole =
        widget.user.roles.isNotEmpty ? widget.user.roles.first : "Customer";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(
              text: "Select User Role",
              style: appStyle(16, AppColors.kDark, FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Column(
              children: allRoles.map((role) {
                return GestureDetector(
                  onTap: () => setState(() => selectedRole = role),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: selectedRole == role
                          ? AppColors.kPrimary.withOpacity(0.15)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: selectedRole == role
                            ? AppColors.kPrimary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedRole == role
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selectedRole == role
                              ? AppColors.kPrimary
                              : Colors.grey,
                        ),
                        SizedBox(width: 12.w),
                        ReusableText(
                          text: role,
                          style: appStyle(
                            14,
                            selectedRole == role
                                ? AppColors.kPrimary
                                : AppColors.kDark,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 25.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () async {
                  await c.updateSingleUserRole(widget.user.id, selectedRole);

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: ReusableText(
                  text: "Save",
                  style: appStyle(14, Colors.white, FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
