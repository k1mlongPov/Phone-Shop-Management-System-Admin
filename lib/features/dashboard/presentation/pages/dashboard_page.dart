import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/advanced_shimmer_dashboard.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/custom_appbar.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/dashboard_summary_row.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/inventory_alerts_row.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/restock_preview.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/sales_comparison_chart.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/top_selling_section.dart';

import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController c = Get.find<DashboardController>();
    final AuthController authCtrl = Get.find<AuthController>();
    final currentUser = authCtrl.user.value;

    return Scaffold(
      backgroundColor: AppColors.kBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: CustomAppbar(user: currentUser!),
      ),
      body: Obx(
        () {
          return RefreshIndicator(
            onRefresh: () async {
              await c.loadDashboard();
              await c.loadHistory();
            },
            child: c.isLoading.value
                ? advancedShimmerDashboard()
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: dashboardHeader(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(child: topSellingSection(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(child: dashboardSummaryRow(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(child: salesChartSection(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(child: inventoryAlertsRow(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(child: restockPreview(c)),
                      SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
