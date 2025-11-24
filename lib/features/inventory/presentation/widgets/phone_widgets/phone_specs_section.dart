import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SpecsSection extends StatelessWidget {
  final TextEditingController osCtrl;
  final TextEditingController chipsetCtrl;
  final TextEditingController ramCtrl;
  final TextEditingController chargingCtrl;

  const SpecsSection({
    super.key,
    required this.osCtrl,
    required this.chipsetCtrl,
    required this.ramCtrl,
    required this.chargingCtrl,
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
            text: 'Specifications (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          children: [
            CustomTextField(
              controller: osCtrl,
              label: 'OS',
              hintText: 'e.g. iOS 18, Android 14',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: ramCtrl,
                    label: 'RAM (GB)',
                    keyboardType: TextInputType.number,
                    hintText: 'e.g. 8',
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: CustomTextField(
                    controller: chargingCtrl,
                    label: 'Charging (Watt)',
                    keyboardType: TextInputType.number,
                    hintText: 'e.g. 67',
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: chipsetCtrl,
              label: 'Chipset',
              hintText: 'e.g. A15 Bionic, Snapdragon 8 Gen 2',
            ),
            SizedBox(height: 16.h),
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
