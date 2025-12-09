import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/restock_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/data/restock_repository.dart';

class RestockPage extends StatelessWidget {
  final String supplierId;

  RestockPage({super.key, required this.supplierId}) {
    if (Get.isRegistered<RestockController>()) {
      Get.delete<RestockController>(force: true);
    }

    c = Get.put(
      RestockController(
        repo: Get.find<RestockRepository>(),
        api: Get.find<ApiService>(),
      ),
    );
  }

  late final RestockController c;

  @override
  Widget build(BuildContext context) {
    // Get supplier passed via Get.arguments
    final SupplierModel argSupplier = Get.arguments as SupplierModel;
    final SupplierController supplierCtrl = Get.find<SupplierController>();

    // Always use the latest supplier (reactive one)
    final SupplierModel supplier = supplierCtrl.suppliers.firstWhere(
      (s) => s.id == argSupplier.id,
      orElse: () => argSupplier,
    );

    // Pass supplier products to controller
    c.suppliedProducts = supplier.suppliedProducts ?? [];
    c.supplierId = supplier.id!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Restock - ${supplier.name}",
            style: appStyle(15, AppColors.kWhite, FontWeight.w600),
          ),
          backgroundColor: AppColors.kPrimary,
        ),
        body: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Note (optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onChanged: (v) => c.note = v,
              ),
              SizedBox(height: 20.h),

              // --------------------
              // RESTOCK ROWS
              // --------------------
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: c.items.length,
                    itemBuilder: (_, index) {
                      final item = c.items[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Row(
                          children: [
                            // PRODUCT PICKER
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => _openProductPicker(context, index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 16.h),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    item['productName'] ?? "Choose product",
                                    style: appStyle(
                                      13,
                                      item['productId'] == null
                                          ? Colors.grey
                                          : AppColors.kDark,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // QUANTITY FIELD
                            Expanded(
                              flex: 1,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "Qty",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  final qty = int.tryParse(v) ?? 1;
                                  c.updateQuantity(index, qty);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              // ADD MORE BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => c.addEmptyItem(),
                  icon: Icon(Icons.add, size: 18.r, color: AppColors.kPrimary),
                  label: Text(
                    "Add item",
                    style: appStyle(13, AppColors.kPrimary, FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // SUBMIT BUTTON
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: c.isLoading.value ? null : c.submitRestock,
                    child: Text(
                      c.isLoading.value ? "Processing..." : "Submit Restock",
                      style: appStyle(14, Colors.white, FontWeight.w600),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _openProductPicker(BuildContext context, int rowIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => ProductPickerSheet(rowIndex: rowIndex),
    );
  }
}

class ProductPickerSheet extends StatelessWidget {
  final int rowIndex;

  const ProductPickerSheet({super.key, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RestockController>();

    return FutureBuilder(
      future: c.fetchSupplierProductDetails(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 300.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final list = c.fetchedProducts;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Text(
                "Select Product",
                style: appStyle(16, AppColors.kDark, FontWeight.w600),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final p = list[i];

                    return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                          child: Icon(
                            p["type"] == "Phone"
                                ? Icons.phone_android
                                : Icons.headset,
                            color: AppColors.kPrimary,
                          ),
                        ),
                        title: Text(
                          p["name"]!,
                          style: appStyle(14, AppColors.kDark, FontWeight.w600),
                        ),
                        subtitle: Text(
                          "ID: ${p["id"]}",
                          style: appStyle(
                              12, Colors.grey.shade700, FontWeight.normal),
                        ),
                        onTap: () {
                          // ACCESSORY
                          if (p["type"] == "Accessory") {
                            c.updateAccessory(
                              index: rowIndex,
                              id: p["id"],
                              name: p["name"],
                            );

                            Get.back();
                            return;
                          }
                          Get.bottomSheet(
                            VariantPickerSheet(
                              rowIndex: rowIndex,
                              phoneId: p["id"],
                              phoneName: p["name"],
                              variants: p["variants"],
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.r)),
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class VariantPickerSheet extends StatelessWidget {
  final int rowIndex;
  final String phoneId;
  final String phoneName;
  final List variants;

  const VariantPickerSheet({
    super.key,
    required this.rowIndex,
    required this.phoneId,
    required this.phoneName,
    required this.variants,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RestockController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          Text(
            "Select Variant",
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: variants.length,
              itemBuilder: (_, i) {
                final v = variants[i];

                return ListTile(
                  title: Text(
                    v["label"],
                    style: appStyle(14, AppColors.kDark, FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Variant ID: ${v['variantId']}",
                    style:
                        appStyle(11, Colors.grey.shade700, FontWeight.normal),
                  ),
                  onTap: () {
                    c.updatePhone(
                      index: rowIndex,
                      id: phoneId,
                      name: phoneName,
                      variantId: v["variantId"],
                      variantLabel: v["label"],
                    );

                    Get.back(); // close variant picker
                    Get.back(); // close product picker
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
