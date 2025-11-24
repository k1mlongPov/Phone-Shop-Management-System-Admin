import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CameraSection extends StatelessWidget {
  final TextEditingController mainCamCtrl;
  final TextEditingController frontCamCtrl;

  const CameraSection({
    super.key,
    required this.mainCamCtrl,
    required this.frontCamCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: ReusableText(
            text: 'Camera (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          children: [
            CustomTextField(
              controller: mainCamCtrl,
              label: 'Main camera',
              hintText: 'e.g. 50MP f/1.8 OIS',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: frontCamCtrl,
              label: 'Front camera',
              hintText: 'e.g. 16MP selfie',
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
      ),
    );
  }
}
