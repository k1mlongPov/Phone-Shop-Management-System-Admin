import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SaleTotalsSection extends StatelessWidget {
  final SaleController controller;

  const SaleTotalsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.fromLTRB(12.w, 50.h, 12.w, 12.h),
        padding: EdgeInsets.all(14.w),
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
        child: Column(
          children: [
            _row("Subtotal", controller.subtotal.value),
            _row("Discount", controller.discount.value),
            _row("Tax", controller.tax.value),
            const Divider(),
            _row("Total", controller.total.value, bold: true),
          ],
        ),
      );
    });
  }

  Widget _row(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: label,
            style: appStyle(
              13,
              bold ? AppColors.kDark : Colors.grey,
              bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          ReusableText(
            text: "\$${amount.toStringAsFixed(2)}",
            style: appStyle(
              13,
              bold ? AppColors.kPrimary : AppColors.kDark,
              bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
