import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/low_stock_page.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/out_of_stock_page.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/section_title.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget inventoryAlertsRow(DashboardController c) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: "Inventory Alerts",
            subtitle: "Keep an eye on stock levels",
            icon: Icons.inventory_2_rounded,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _InventoryAlertCard(
                  title: "Low Stock Items",
                  count: c.lowStockCount,
                  color: Colors.orange,
                  onTap: () => Get.to(() => LowStockPage()),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _InventoryAlertCard(
                  title: "Out of Stock",
                  count: c.outStockCount,
                  color: Colors.red,
                  onTap: () => Get.to(() => const OutOfStockPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _InventoryAlertCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _InventoryAlertCard({
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      tween: Tween(begin: 0, end: 1),
      builder: (_, t, child) {
        return Transform.scale(
          scale: 0.98 + t * 0.02,
          child: Opacity(opacity: t, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: color.withOpacity(0.12),
                child:
                    Icon(Icons.warning_amber_rounded, color: color, size: 18.r),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: title,
                      style: appStyle(12, AppColors.kDark, FontWeight.w600),
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: "$count items",
                      style:
                          appStyle(11, Colors.grey.shade700, FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
