import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Future<void> showSelectBottomSheet({
  required BuildContext context,
  required String title,
  required List<Map<String, String?>> options,
  required Function(String? value) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: AppColors.kWhite,
    isScrollControlled: true,
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            height: AppSize.height * .5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---- Drag Handle ----
                Container(
                  width: 40.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                SizedBox(height: 12.h),

                // ---- Title ----
                ReusableText(
                  text: title,
                  style: appStyle(16, AppColors.kDark, FontWeight.w600),
                ),

                SizedBox(height: 10.h),
                Divider(height: 1.h),

                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (_, index) {
                      final opt = options[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          onSelected(opt["value"]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 8.w),
                          child: ReusableText(
                            text: opt["label"] ?? "",
                            style: appStyle(
                              14,
                              AppColors.kDark,
                              FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
