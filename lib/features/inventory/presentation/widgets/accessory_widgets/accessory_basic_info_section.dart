import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/show_select_bottom_modal.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AccessoryBasicInfoSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController typeCtrl;
  final TextEditingController brandCtrl;
  final TextEditingController purchaseCtrl;
  final TextEditingController sellingCtrl;
  final TextEditingController stockCtrl;
  final TextEditingController lowStockCtrl;

  final String currency;
  final Function(String) onSelectCurrency;

  final String? selectedCategoryId;
  final Function(String?) onSelectCategory;

  final String? selectedSupplierId;
  final Function(String?) onSelectSupplier;

  const AccessoryBasicInfoSection({
    super.key,
    required this.nameCtrl,
    required this.typeCtrl,
    required this.brandCtrl,
    required this.purchaseCtrl,
    required this.sellingCtrl,
    required this.stockCtrl,
    required this.lowStockCtrl,
    required this.currency,
    required this.onSelectCurrency,
    required this.selectedCategoryId,
    required this.onSelectCategory,
    required this.selectedSupplierId,
    required this.onSelectSupplier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Basic Info',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),

          CustomTextField(
            controller: nameCtrl,
            label: 'Name *',
            hintText: 'e.g. Phone case, Charger',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          SizedBox(height: 10.h),

          CustomTextField(
            controller: typeCtrl,
            label: 'Type *',
            hintText: 'e.g. case, cable, charger',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Type is required' : null,
          ),
          SizedBox(height: 10.h),

          CustomTextField(
            controller: brandCtrl,
            label: 'Brand',
            hintText: 'e.g. Baseus, UGreen (optional)',
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: purchaseCtrl,
                  label: 'Purchase price *',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final d = double.tryParse(v);
                    if (d == null) return 'Invalid';
                    if (d < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomTextField(
                  controller: sellingCtrl,
                  label: 'Selling price *',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final d = double.tryParse(v);
                    if (d == null) return 'Invalid';
                    if (d < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          CustomTextField(
            readOnly: true,
            label: "Currency",
            controller: TextEditingController(
              text: currency.isEmpty ? "Select currency" : currency,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            onTap: () {
              showSelectBottomSheet(
                context: context,
                title: "Select Currency",
                options: const [
                  {"value": "USD", "label": "USD (\$)"},
                  {"value": "KHR", "label": "KHR (៛)"},
                ],
                onSelected: (val) {
                  if (val != null) onSelectCurrency(val);
                },
              );
            },
          ),

          SizedBox(height: 10.h),

          /// CATEGORY
          GetX<SubCategoryController>(
            builder: (subCtrl) {
              final parentId = subCtrl.activeParentId.value;
              final subs = subCtrl.getSubcategories(parentId);

              final selected = subs.firstWhereOrNull(
                (c) => c.id == selectedCategoryId,
              );

              return CustomTextField(
                readOnly: true,
                label: "Category (subcategory)",
                controller: TextEditingController(
                  text: selected?.name ?? "Select category *",
                ),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                validator: (_) {
                  if (selectedCategoryId == null ||
                      selectedCategoryId!.isEmpty) {
                    return "Please select a category";
                  }
                  return null;
                },
                onTap: () {
                  if (subs.isEmpty) {
                    Get.snackbar("No categories",
                        "No accessory subcategories available");
                    return;
                  }

                  showSelectBottomSheet(
                    context: context,
                    title: "Select Category",
                    options: subs
                        .map(
                          (c) => {"value": c.id, "label": c.name},
                        )
                        .toList(),
                    onSelected: (val) {
                      onSelectCategory(val);
                    },
                  );
                },
              );
            },
          ),

          SizedBox(height: 10.h),

          /// SUPPLIER
          GetX<SupplierController>(
            builder: (supCtrl) {
              final selected = supCtrl.suppliers
                  .firstWhereOrNull((s) => s.id == selectedSupplierId);

              return CustomTextField(
                readOnly: true,
                label: "Supplier",
                controller: TextEditingController(
                  text: selected?.name ??
                      (selectedSupplierId == null
                          ? "Select supplier *"
                          : "Select supplier"),
                ),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                validator: (_) {
                  if (selectedSupplierId == null ||
                      selectedSupplierId!.isEmpty) {
                    return "Please select a supplier";
                  }
                  return null;
                },
                onTap: () {
                  if (supCtrl.suppliers.isEmpty) {
                    Get.snackbar(
                      "No suppliers",
                      "Please add suppliers first.",
                    );
                    return;
                  }

                  showSelectBottomSheet(
                    context: context,
                    title: "Select Supplier",
                    options: supCtrl.suppliers
                        .map(
                          (s) => {"value": s.id, "label": s.name},
                        )
                        .toList(),
                    onSelected: (val) => onSelectSupplier(val),
                  );
                },
              );
            },
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: stockCtrl,
                  label: 'Stock',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomTextField(
                  controller: lowStockCtrl,
                  label: 'Low stock threshold',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          const Divider(color: AppColors.kGray, thickness: 1),
        ],
      ),
    );
  }
}
