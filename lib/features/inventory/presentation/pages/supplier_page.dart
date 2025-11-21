import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';

import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';
import 'package:shimmer/shimmer.dart';

class SupplierPage extends StatelessWidget {
  SupplierPage({super.key});

  final SupplierController controller = Get.find<SupplierController>();

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
      child: Slidable(
        key: ValueKey(s.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            // EDIT
            SlidableAction(
              onPressed: (_) async {
                await Future.delayed(const Duration(milliseconds: 200));
                _showEditDialog(s);
              },
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),

            // DELETE
            SlidableAction(
              onPressed: (_) async {
                await Future.delayed(const Duration(milliseconds: 200));
                controller.deleteSupplier(s.id ?? "");
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(17, 17, 26, 0.1),
                blurRadius: 16,
                spreadRadius: 0,
                offset: Offset(0, 0),
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
                  style: appStyle(12, s.active ? Colors.green : Colors.red,
                      FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // SHIMMER LOADER
  // ---------------------------------------------------
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(12.r),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // EDIT DIALOG
  // ---------------------------------------------------
  Future<void> _showEditDialog(SupplierModel s) async {
    final nameCtrl = TextEditingController(text: s.name);
    final contactCtrl = TextEditingController(text: s.contactName ?? "");
    final phoneCtrl = TextEditingController(text: s.phone ?? "");
    final emailCtrl = TextEditingController(text: s.email ?? "");
    final addressCtrl = TextEditingController(text: s.address ?? "");
    final isActive = RxBool(s.active);

    await Get.generalDialog(
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 0.85.sw,
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableText(
                    text: "Edit Supplier",
                    style: appStyle(18, AppColors.kDark, FontWeight.w600),
                  ),
                  SizedBox(height: 14.h),
                  CustomTextField(
                      controller: nameCtrl, hintText: "Supplier Name"),
                  SizedBox(height: 12.h),
                  CustomTextField(
                      controller: contactCtrl, hintText: "Contact Name"),
                  SizedBox(height: 12.h),
                  CustomTextField(controller: phoneCtrl, hintText: "Phone"),
                  SizedBox(height: 12.h),
                  CustomTextField(controller: emailCtrl, hintText: "Email"),
                  SizedBox(height: 12.h),
                  CustomTextField(controller: addressCtrl, hintText: "Address"),
                  SizedBox(height: 12.h),
                  Obx(() => SwitchListTile(
                        value: isActive.value,
                        title: const Text("Active"),
                        onChanged: (v) => isActive.value = v,
                      )),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("Cancel",
                            style:
                                appStyle(14, AppColors.kDark, FontWeight.w500)),
                      ),
                      SizedBox(width: 6.w),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                        ),
                        onPressed: () async {
                          final ok = await controller.updateSupplier(
                            s.id ?? "",
                            {
                              "name": nameCtrl.text,
                              "contactName": contactCtrl.text,
                              "phone": phoneCtrl.text,
                              "email": emailCtrl.text,
                              "address": addressCtrl.text,
                              "active": isActive.value,
                            },
                          );

                          if (ok) Get.back();
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
