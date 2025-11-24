import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class DisplaySection extends StatelessWidget {
  final TextEditingController sizeCtrl;
  final TextEditingController resCtrl;
  final TextEditingController typeCtrl;
  final TextEditingController refreshCtrl;

  const DisplaySection({
    super.key,
    required this.sizeCtrl,
    required this.resCtrl,
    required this.typeCtrl,
    required this.refreshCtrl,
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
            text: 'Display (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          children: [
            const SizedBox(height: 4),
            CustomTextField(
              controller: sizeCtrl,
              label: 'Size (inches)',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              hintText: 'e.g. 6.7',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: resCtrl,
              label: 'Resolution',
              hintText: 'e.g. 1080x2400',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: typeCtrl,
              label: 'Type',
              hintText: 'e.g. AMOLED, IPS',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: refreshCtrl,
              label: 'Refresh rate (Hz)',
              keyboardType: TextInputType.number,
              hintText: 'e.g. 120',
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
