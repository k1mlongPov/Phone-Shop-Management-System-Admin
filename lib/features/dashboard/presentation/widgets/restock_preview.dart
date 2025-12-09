import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/restock_history_page.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/section_title.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget restockPreview(DashboardController c) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Recent Restock",
          subtitle: "Latest products received",
          icon: Icons.refresh_rounded,
          action: TextButton(
            onPressed: () => Get.to(() => RestockHistoryPage()),
            child: ReusableText(
              text: "View all",
              style: appStyle(12, AppColors.kPrimary, FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (c.entries.isEmpty) {
            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: _cardBox(),
              child: Center(
                child: ReusableText(
                  text: "No restock records yet",
                  style: appStyle(12, Colors.grey, FontWeight.normal),
                ),
              ),
            );
          }

          final recent = c.entries.take(5).toList();

          return Container(
            padding: EdgeInsets.all(10.w),
            decoration: _cardBox(),
            child: Column(
              children: recent.map((e) {
                final isPhone = e.modelType == "Phone";
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor: AppColors.kPrimary.withOpacity(0.08),
                        child: Icon(
                          isPhone ? Icons.phone_android : Icons.headset_rounded,
                          color: AppColors.kPrimary,
                          size: 18.r,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: e.productName,
                              style: appStyle(
                                  13, AppColors.kDark, FontWeight.w600),
                            ),
                            if (e.variantLabel != null &&
                                e.variantLabel!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: ReusableText(
                                  text: e.variantLabel!,
                                  style: appStyle(11, Colors.grey.shade700,
                                      FontWeight.w500),
                                ),
                              ),
                            SizedBox(height: 2.h),
                            ReusableText(
                              text: "Supplier: ${e.supplierName}",
                              style: appStyle(
                                11,
                                Colors.grey.shade700,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReusableText(
                        text: "+${e.quantity}",
                        style: appStyle(
                            12, Colors.green.shade700, FontWeight.w700),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    ),
  );
}

BoxDecoration _cardBox() {
  return BoxDecoration(
    color: AppColors.kWhite,
    borderRadius: BorderRadius.circular(14.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 3),
      )
    ],
  );
}
