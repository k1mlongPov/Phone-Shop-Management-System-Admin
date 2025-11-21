import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';

class WarrantyExpiringWidget extends GetView<DashboardController> {
  const WarrantyExpiringWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Warranties Expiring Soon",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...controller.warrantyExpiring.map(
                (w) => Material(
                  color: AppColors.kWhite,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(w),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
