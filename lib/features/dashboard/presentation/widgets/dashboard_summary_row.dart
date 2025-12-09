import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget dashboardSummaryRow(DashboardController c) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Obx(
      () => Row(
        children: [
          Expanded(
            child: _DashboardCard(
              label: "Today's Sales",
              value: "\$${c.todaySales.toStringAsFixed(2)}",
              icon: Icons.payments_rounded,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _DashboardCard(
              label: "Invoices Today",
              value: c.todayInvoices.value.toString(),
              icon: Icons.receipt_long_rounded,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _DashboardCard(
              label: "New Customers",
              value: c.newCustomersToday.value.toString(),
              icon: Icons.person_add_alt_1_rounded,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DashboardCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      tween: Tween(begin: 0, end: 1),
      builder: (_, t, child) {
        return Transform.translate(
          offset: Offset(0, (1 - t) * 12),
          child: Opacity(opacity: t, child: child),
        );
      },
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
              radius: 12.r,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 18.r),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: label,
                    style: appStyle(11, Colors.grey.shade700, FontWeight.w500),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text: value,
                    style: appStyle(13, AppColors.kDark, FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
