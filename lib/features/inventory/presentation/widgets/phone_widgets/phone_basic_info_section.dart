import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/show_select_bottom_modal.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PhoneBasicInfoSection extends StatelessWidget {
  final TextEditingController brandCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController purchaseCtrl;
  final TextEditingController sellingCtrl;

  final String currency;
  final Function(String value) onCurrencyChanged;

  final String? selectedCategoryId;
  final Function(String?) onCategoryChanged;

  final String? selectedSupplierId;
  final Function(String?) onSupplierChanged;

  const PhoneBasicInfoSection({
    super.key,
    required this.brandCtrl,
    required this.modelCtrl,
    required this.purchaseCtrl,
    required this.sellingCtrl,
    required this.currency,
    required this.onCurrencyChanged,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.selectedSupplierId,
    required this.onSupplierChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Basic Info',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: brandCtrl,
            label: 'Brand *',
            hintText: 'e.g. iPhone, Samsung',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Brand is required' : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: modelCtrl,
            label: 'Model *',
            hintText: 'e.g. 13 Pro Max',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Model is required' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: purchaseCtrl,
                  label: 'Purchase price *',
                  hintText: '0',
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
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  controller: sellingCtrl,
                  label: 'Selling price *',
                  hintText: '0',
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
          const SizedBox(height: 10),
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
                options: [
                  {"value": "USD", "label": "USD (\$)"},
                  {"value": "KHR", "label": "KHR (៛)"},
                ],
                onSelected: (val) => onCurrencyChanged(val!),
              );
            },
          ),
          const SizedBox(height: 10),
          GetX<SubCategoryController>(
            builder: (subCtrl) {
              final parentId = subCtrl.activeParentId.value;
              final subs = subCtrl.getSubcategories(parentId);
              final selectedCat =
                  subs.firstWhereOrNull((c) => c.id == selectedCategoryId);
              final selectedName = selectedCat?.name ?? "Select category *";

              return CustomTextField(
                readOnly: true,
                label: "Category (subcategory)",
                controller: TextEditingController(text: selectedName),
                suffixIcon: const Icon(Icons.arrow_drop_down),

                // ✨ ADD THIS
                validator: (_) {
                  if (selectedCategoryId == null) {
                    return "Please select a category";
                  }
                  return null;
                },

                onTap: () {
                  showSelectBottomSheet(
                    context: context,
                    title: "Select Category",
                    options: [
                      ...subs.map(
                        (c) => {
                          "value": c.id,
                          "label": c.name,
                        },
                      ),
                    ],
                    onSelected: (val) => onCategoryChanged(val),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          GetX<SupplierController>(
            builder: (sup) {
              final selectedSup = sup.suppliers
                  .firstWhereOrNull((s) => s.id == selectedSupplierId);

              String selectedName;

              if (selectedSupplierId == null) {
                selectedName = "Select supplier *";
              } else if (selectedSupplierId!.isEmpty) {
                selectedName = "None"; // show None when value is ""
              } else {
                selectedName = selectedSup?.name ?? "Select supplier";
              }

              return CustomTextField(
                readOnly: true,
                label: "Supplier",
                controller: TextEditingController(text: selectedName),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                validator: (_) {
                  if (selectedSupplierId == null) {
                    return "Please select a supplier";
                  }
                  return null;
                },
                onTap: () {
                  showSelectBottomSheet(
                    context: context,
                    title: "Select Supplier",
                    options: [
                      {"value": "none", "label": "None"},
                      ...sup.suppliers.map(
                        (s) => {
                          "value": s.id,
                          "label": s.name,
                        },
                      ),
                    ],
                    onSelected: (val) {
                      if (val == "none") {
                        // user selected None → send "" to backend
                        onSupplierChanged("");
                      } else {
                        onSupplierChanged(val);
                      }
                    },
                  );
                },
              );
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          const Divider(
            color: AppColors.kGray,
            thickness: 1,
            height: 2,
          ),
        ],
      ),
    );
  }
}
