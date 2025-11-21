import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class KpiRow extends GetView<DashboardController> {
  const KpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            _kpi('Today Sales', '\$${controller.todaySales.value}', Icons.sell),
            SizedBox(width: 12.w),
            _kpi('Invoices', controller.todayInvoices.value.toString(),
                Icons.receipt),
          ],
        ));
  }

  Widget _kpi(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kPrimary, size: 26.sp),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                    text: title,
                    style: appStyle(12, AppColors.kGray, FontWeight.w600)),
                SizedBox(height: 6.h),
                ReusableText(
                    text: value,
                    style: appStyle(16, AppColors.kDark, FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
