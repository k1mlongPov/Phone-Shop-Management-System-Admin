import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/domain/models/top_selling_item.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget topSellingSection(DashboardController c) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: AppColors.kWhite,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: "🔥 Top Selling Products",
          style: appStyle(16, AppColors.kDark, FontWeight.bold),
        ),
        SizedBox(height: 10.h),

        // Toggle Weekly / Monthly
        Obx(() => Row(
              children: [
                _toggleChip("Weekly", c.topMode.value == "weekly", () {
                  c.topMode("weekly");
                }),
                SizedBox(width: 8.w),
                _toggleChip("Monthly", c.topMode.value == "monthly", () {
                  c.topMode("monthly");
                }),
              ],
            )),

        SizedBox(height: 12.h),

        Obx(() {
          final list = c.topMode.value == "weekly"
              ? c.weeklyTopSelling
              : c.monthlyTopSelling;

          if (list.isEmpty) {
            return Center(
              child: ReusableText(
                text: "No sales yet",
                style: appStyle(13, Colors.grey, FontWeight.normal),
              ),
            );
          }

          return Column(
            children: List.generate(list.length, (i) {
              final item = list[i];
              return _topSellingTile(item, i + 1);
            }),
          );
        })
      ],
    ),
  );
}

Widget _topSellingTile(TopSellingItem item, int rank) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: AppColors.kWhite,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.03),
          blurRadius: 5,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.kPrimary.withOpacity(0.12),
          child: ReusableText(
            text: "#$rank",
            style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: item.name,
                style: appStyle(14, AppColors.kDark, FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              ReusableText(
                text: item.modelType,
                style: appStyle(11, Colors.grey, FontWeight.normal),
              ),
            ],
          ),
        ),
        ReusableText(
          text: "${item.quantity} sold",
          style: appStyle(13, AppColors.kPrimary, FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _toggleChip(String label, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.kPrimary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ReusableText(
        text: label,
        style: appStyle(
          12,
          selected ? AppColors.kWhite : AppColors.kDark,
          FontWeight.w600,
        ),
      ),
    ),
  );
}
