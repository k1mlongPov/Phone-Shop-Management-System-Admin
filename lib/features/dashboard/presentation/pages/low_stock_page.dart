import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';

class LowStockPage extends StatelessWidget {
  LowStockPage({super.key});

  final DashboardController c = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Low Stock Items",
          style: appStyle(16, AppColors.kWhite, FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: AppColors.kWhite, size: 22.r),
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final phones = c.lowStockPhones;
        final accessories = c.lowStockAccessories;

        final total = phones.length + accessories.length;

        if (total == 0) {
          return Center(
            child: Text(
              "No low stock items 🎉",
              style: appStyle(15, Colors.grey.shade700, FontWeight.w500),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => c.loadDashboard(),
          child: ListView(
            padding: EdgeInsets.all(14.r),
            children: [
              // --- HEADER COUNT ---
              Text(
                "Total Low Stock: $total",
                style: appStyle(16, AppColors.kDark, FontWeight.w700),
              ),

              SizedBox(height: 16.h),

              // --- PHONES SECTION ---
              if (phones.isNotEmpty) ...[
                Text(
                  "Phones (${phones.length})",
                  style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                ...phones.map(_buildPhoneCard),
                SizedBox(height: 20.h),
              ],

              // --- ACCESSORIES SECTION ---
              if (accessories.isNotEmpty) ...[
                Text(
                  "Accessories (${accessories.length})",
                  style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                ...accessories.map(_buildAccessoryCard),
              ],
            ],
          ),
        );
      }),
    );
  }

  // ----------------------------------------------------------------------
  // PHONE CARD
  // ----------------------------------------------------------------------
  Widget _buildPhoneCard(phone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android, size: 26.r, color: AppColors.kPrimary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${phone.brand} ${phone.model}",
                  style: appStyle(14, AppColors.kDark, FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Stock: ${phone.totalStock} | Threshold: ${phone.lowStockThreshold}",
                  style: appStyle(12, Colors.grey.shade700, FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // ACCESSORY CARD
  // ----------------------------------------------------------------------
  Widget _buildAccessoryCard(accessory) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.headset, size: 26.r, color: AppColors.kPrimary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accessory.name,
                  style: appStyle(14, AppColors.kDark, FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Stock: ${accessory.stock} | Threshold: ${accessory.lowStockThreshold}",
                  style: appStyle(12, Colors.grey.shade700, FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
