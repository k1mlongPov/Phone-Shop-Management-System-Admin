import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AttributeRow {
  final TextEditingController keyCtrl;
  final TextEditingController valueCtrl;

  AttributeRow({String? key, String? value})
      : keyCtrl = TextEditingController(text: key),
        valueCtrl = TextEditingController(text: value);
}

class AccessoryAttributesSection extends StatelessWidget {
  final List<AttributeRow> attributes;
  final VoidCallback onAddAttribute;
  final Function(int) onRemoveAttribute;

  const AccessoryAttributesSection({
    super.key,
    required this.attributes,
    required this.onAddAttribute,
    required this.onRemoveAttribute,
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
            text: 'Attributes (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          ReusableText(
            text: 'Add any extra info as key / value pairs.',
            style: appStyle(12, AppColors.kGray, FontWeight.normal),
          ),
          SizedBox(height: 8.h),
          ...List.generate(attributes.length, (i) {
            final item = attributes[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: item.keyCtrl,
                      hintText: 'Key',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: item.valueCtrl,
                      hintText: 'Value',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  if (attributes.length > 1)
                    IconButton(
                      onPressed: () => onRemoveAttribute(i),
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            );
          }),
          SizedBox(height: 4.h),
          TextButton.icon(
            onPressed: onAddAttribute,
            icon: Icon(
              Icons.add,
              size: 22.r,
              color: AppColors.kPrimary,
            ),
            label: ReusableText(
              text: 'Add attribute',
              style: appStyle(13, AppColors.kPrimary, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
