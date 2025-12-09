import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/customer_picker_bottomsheet.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SaleCustomerSelector extends StatelessWidget {
  final SaleController controller;

  const SaleCustomerSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await Get.bottomSheet(
          CustomerPickerBottomSheet(),
          isScrollControlled: true,
        );
        if (picked != null) {
          controller.selectedCustomer.value = picked;
        }
      },
      child: Obx(
        () {
          final cust = controller.selectedCustomer.value;

          return Container(
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(9, 30, 66, 0.25),
                  blurRadius: 1,
                  spreadRadius: 0,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Color.fromRGBO(9, 30, 66, 0.13),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppColors.kPrimary),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: cust?.name ?? "Select Customer",
                      style: appStyle(
                        14,
                        cust == null ? Colors.grey : AppColors.kDark,
                        FontWeight.w600,
                      ),
                    ),
                    if (cust?.phone != null)
                      ReusableText(
                        text: cust!.phone!,
                        style: appStyle(12, Colors.grey, FontWeight.normal),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
