import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AccessoryCompatibilitySection extends StatelessWidget {
  final TextEditingController compatibilityCtrl;

  const AccessoryCompatibilitySection({
    super.key,
    required this.compatibilityCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 0.h),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Compatibility (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: compatibilityCtrl,
            label: 'Compatible devices',
            hintText: 'e.g. iPhone 13, Galaxy S22 (comma separated)',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
