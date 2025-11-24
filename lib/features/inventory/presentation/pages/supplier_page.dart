import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/supplier_widgets/supplier_shimmer.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/create_supplier_button_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/supplier_detail_page.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';

class SupplierPage extends StatelessWidget {
  SupplierPage({super.key});

  final SupplierController controller = Get.find<SupplierController>();
  void openCreateSupplierSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CreateSupplierBottomSheet(),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        }

        if (controller.suppliers.isEmpty) {
          return const Center(child: Text("No suppliers found"));
        }

        final lastUpdated = controller.suppliers.isNotEmpty
            ? DateFormat('dd MMM yyyy').format(
                controller.suppliers
                    .map((s) =>
                        DateTime.tryParse(s.updatedAt ?? "") ?? DateTime.now())
                    .reduce((a, b) => a.isAfter(b) ? a : b),
              )
            : 'N/A';

        return RefreshIndicator(
          color: AppColors.kPrimary,
          onRefresh: controller.fetchSuppliers,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: ListView(
              children: [
                _buildSummaryCard(
                  count: controller.suppliers.length,
                  lastUpdated: lastUpdated,
                  onRefresh: controller.fetchSuppliers,
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => openCreateSupplierSheet(context),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.w, top: 10.h),
                    height: 45.h,
                    decoration: BoxDecoration(
                      border: Border.all(width: .6, color: AppColors.kPrimary),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: AppColors.kPrimary,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        ReusableText(
                          text: 'Add new Supplier',
                          style: appStyle(
                              14, AppColors.kPrimary, FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ...controller.suppliers.map((s) => _buildSupplierTile(s)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------
  // SUMMARY CARD
  // ---------------------------------------------------
  Widget _buildSummaryCard({
    required int count,
    required String lastUpdated,
    required VoidCallback onRefresh,
  }) {
    return Container(
      width: AppSize.width,
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(60, 64, 67, 0.3),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(60, 64, 67, 0.15),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Icon(Icons.store, size: 34.r, color: AppColors.kWhite),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: "Suppliers",
                    style: appStyle(14, AppColors.kWhite, FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Total: $count • Last updated: $lastUpdated",
                    style: appStyle(
                      12,
                      AppColors.kWhite.withOpacity(.8),
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(
                Icons.refresh,
                color: AppColors.kWhite,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // SUPPLIER TILE
  // ---------------------------------------------------
  Widget _buildSupplierTile(SupplierModel s) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.kWhite,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 18.r,
            backgroundColor: s.active ? Colors.green : Colors.red,
            child: Icon(Icons.person, color: Colors.white, size: 20.r),
          ),
          title: Text(s.name ?? "-",
              style: appStyle(14, AppColors.kDark, FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (s.phone != null && s.phone!.isNotEmpty)
                Text("📞 ${s.phone}",
                    style: appStyle(12, Colors.grey, FontWeight.normal)),
              if (s.email != null && s.email!.isNotEmpty)
                Text("✉️ ${s.email}",
                    style: appStyle(12, Colors.grey, FontWeight.normal)),
              Text(
                s.active ? "Active" : "Inactive",
                style: appStyle(
                    12, s.active ? Colors.green : Colors.red, FontWeight.w500),
              ),
            ],
          ),
          trailing: GestureDetector(
            onTap: () => Get.to(
              () => const SupplierDetailPage(),
              arguments: s,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(12.r),
      itemCount: 4,
      itemBuilder: (_, __) => const SupplierShimmer(),
    );
  }
}
