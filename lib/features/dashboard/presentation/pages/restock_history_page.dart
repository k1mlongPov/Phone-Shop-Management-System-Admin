import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/restock_history_tile.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class RestockHistoryPage extends StatelessWidget {
  RestockHistoryPage({super.key});

  final DashboardController c = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Restock History",
          style: appStyle(16, Colors.white, FontWeight.w600),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: AppColors.kWhite, size: 22.r),
        ),
      ),
      body: Obx(
        () {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.entries.isEmpty) {
            return Center(
              child: ReusableText(
                text: "No restock history found.",
                style: appStyle(13, Colors.grey.shade700, FontWeight.w500),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: c.loadHistory,
            child: ListView.separated(
              padding: EdgeInsets.all(12.r),
              itemCount: c.entries.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (_, index) {
                final item = c.entries[index];
                return RestockHistoryTile(entry: item);
              },
            ),
          );
        },
      ),
    );
  }
}
