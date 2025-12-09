import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget dashboardHeader(DashboardController c) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.kPrimary,
          AppColors.kPrimary.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.kPrimary.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: 'Welcome to Vetheary Phone Store',
                style: appStyle(14, AppColors.kWhite, FontWeight.normal),
              ),
              SizedBox(height: 6.h),
              ReusableText(
                text: 'Dashboard Overview',
                style: appStyle(18, AppColors.kWhite, FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => ReusableText(
                  text:
                      "Today: \$${c.todaySales} • ${c.todayInvoices} invoices",
                  style: appStyle(
                    12,
                    Colors.white.withOpacity(0.9),
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.dashboard_rounded,
          color: Colors.white.withOpacity(0.9),
          size: 32.r,
        ),
      ],
    ),
  );
}
