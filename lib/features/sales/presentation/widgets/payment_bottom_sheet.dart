import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';

import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';

class PaymentBottomSheet extends StatefulWidget {
  final SaleController controller;

  const PaymentBottomSheet({super.key, required this.controller});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController paidCtrl = TextEditingController();
  String paymentMethod = "cash";

  @override
  void initState() {
    super.initState();
    paidCtrl.text = widget.controller.total.value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 10.h),
            _summaryCard(),
            SizedBox(height: 20.h),
            _paymentMethodSelector(),
            SizedBox(height: 20.h),
            ReusableText(
              text: "Amount Paid",
              style: appStyle(14, AppColors.kDark, FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: paidCtrl,
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Center(
      child: Container(
        width: 45.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    final c = widget.controller;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
          )
        ],
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Subtotal", "\$${c.subtotal.value.toStringAsFixed(2)}"),
            SizedBox(height: 6.h),
            _row("Discount", "-\$${c.discount.value.toStringAsFixed(2)}"),
            SizedBox(height: 6.h),
            _row("Tax", "+\$${c.tax.value.toStringAsFixed(2)}"),
            Divider(height: 18.h),
            _row(
              "Total",
              "\$${c.total.value.toStringAsFixed(2)}",
              isBold: true,
            ),
          ],
        );
      }),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
          text: label,
          style: appStyle(
              14, AppColors.kDark, isBold ? FontWeight.w700 : FontWeight.w500),
        ),
        ReusableText(
          text: value,
          style: appStyle(14, AppColors.kPrimary,
              isBold ? FontWeight.w700 : FontWeight.w500),
        ),
      ],
    );
  }

  Widget _paymentMethodSelector() {
    final methods = ["Cash", "Card", "ABA", "Wing", "ACLEDA"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: "Payment Method",
          style: appStyle(14, AppColors.kDark, FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          children: methods.map((m) {
            final bool selected = paymentMethod == m;
            return GestureDetector(
              onTap: () => setState(() => paymentMethod = m),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: selected ? AppColors.kPrimary : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: ReusableText(
                  text: m,
                  style: appStyle(
                    12,
                    selected ? AppColors.kWhite : AppColors.kDark,
                    FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _submitButton() {
    final c = widget.controller;

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: c.isSubmitting.value
              ? null
              : () async {
                  final paid = double.tryParse(paidCtrl.text) ?? 0;

                  final invoice = await c.submitSale(
                    paidAmount: paid,
                    paymentMethod: paymentMethod.toLowerCase(),
                  );

                  if (invoice != null) {
                    Get.back(); // close sheet
                    Get.snackbar(
                      "Success",
                      "Sale completed!",
                      backgroundColor: Colors.green.shade600,
                      colorText: Colors.white,
                    );
                  }
                },
          child: c.isSubmitting.value
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : ReusableText(
                  text: "Confirm Payment",
                  style: appStyle(14, Colors.white, FontWeight.w600),
                ),
        ),
      );
    });
  }
}
