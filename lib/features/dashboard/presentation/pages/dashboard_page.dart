import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/kip_row.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/low_stock_widget.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/recent_sales_widget.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/top_selling_widget.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/warranty_expiring_widget.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            ReusableText(
              text: 'Dashboard',
              style: appStyle(20, AppColors.kDark, FontWeight.bold),
            ),

            SizedBox(height: 20.h),

            // KPI CARDS (Today sales, invoices, low stock, new customers)
            const KpiRow(),

            SizedBox(height: 22.h),

            // Top selling products this week
            const TopSellingWidget(),

            SizedBox(height: 22.h),

            // Recent Sales / Invoices
            const RecentSalesWidget(),

            SizedBox(height: 22.h),

            // Low stock
            const LowStockWidget(),

            SizedBox(height: 22.h),

            // Warranty expiring soon
            const WarrantyExpiringWidget(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
