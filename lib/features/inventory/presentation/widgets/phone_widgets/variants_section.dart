import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class VariantsSection extends StatelessWidget {
  final List<dynamic> variants;
  final VoidCallback onAddVariant;
  final Function(int index) onRemoveVariant;
  final Function(int index, String condition) onChangeCondition;

  const VariantsSection({
    super.key,
    required this.variants,
    required this.onAddVariant,
    required this.onRemoveVariant,
    required this.onChangeCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Variants',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add multiple storage / color / condition options.',
            style: appStyle(12, AppColors.kGray, FontWeight.w400),
          ),
          SizedBox(height: 10.h),

          // LIST
          Column(
            children: List.generate(
              variants.length,
              (i) {
                final v = variants[i];

                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                    border:
                        Border.all(color: Colors.grey.shade300, width: 0.6.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ReusableText(
                            text: 'Variant ${i + 1}',
                            style:
                                appStyle(14, AppColors.kDark, FontWeight.w600),
                          ),
                          const Spacer(),
                          if (variants.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.kRed),
                              onPressed: () => onRemoveVariant(i),
                            ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: v.storageCtrl,
                              label: 'Storage',
                              hintText: '128GB',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: v.colorCtrl,
                              label: 'Color',
                              hintText: 'Black',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Purchase + Selling
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: v.purchaseCtrl,
                              label: 'Purchase price',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: '0',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: v.sellingCtrl,
                              label: 'Selling price',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: '0',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: v.stockCtrl,
                        label: 'Stock',
                        keyboardType: TextInputType.number,
                        hintText: '0',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: ReusableText(
                          text: 'Condition',
                          style: appStyle(13, AppColors.kDark, FontWeight.w400),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['new', 'imported', 'used'].map((c) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: c,
                                groupValue:
                                    v.condition, // current selected value
                                onChanged: (value) =>
                                    onChangeCondition(i, value!),
                                activeColor: AppColors.kPrimary,
                              ),
                              Text(
                                c,
                                style: appStyle(
                                    14, AppColors.kDark, FontWeight.normal),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          TextButton.icon(
            onPressed: onAddVariant,
            icon: Icon(
              Icons.add,
              color: AppColors.kPrimary,
              size: 22.r,
            ),
            label: ReusableText(
              text: 'Add variant',
              style: appStyle(14, AppColors.kPrimary, FontWeight.w500),
            ),
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
