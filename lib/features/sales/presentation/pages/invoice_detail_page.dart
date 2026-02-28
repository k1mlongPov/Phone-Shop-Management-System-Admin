import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class InvoiceDetailPage extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.kWhite,
          ),
        ),
        title: ReusableText(
          text: '#${invoice.invoiceNo}',
          style: appStyle(18, AppColors.kWhite, FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: "Customer: ${invoice.customerName}",
              style: appStyle(16, AppColors.kDark, FontWeight.w500),
            ),
            SizedBox(height: 6.h),
            ReusableText(
              text: "Phone: ${invoice.customerPhone}",
              style: appStyle(14, AppColors.kDark, FontWeight.w400),
            ),
            const SizedBox(height: 10),
            ReusableText(
              text: "Items",
              style: appStyle(16, AppColors.kDark, FontWeight.w500),
            ),
            ...invoice.items.map(
              (i) => ListTile(
                title: ReusableText(
                  text: i.productName,
                  style: appStyle(15, AppColors.kDark, FontWeight.w600),
                ),
                subtitle: ReusableText(
                  text: "${i.quantity} × \$${i.unitPrice}",
                  style: appStyle(14, AppColors.kGray, FontWeight.w400),
                ),
                trailing: ReusableText(
                  text: "\$${i.totalPrice}",
                  style: appStyle(14, AppColors.kPrimary, FontWeight.w400),
                ),
              ),
            ),
            const Divider(),
            SizedBox(height: 6.h),
            ReusableText(
              text: "Subtotal: \$${invoice.subtotal}",
              style: appStyle(14, AppColors.kDark, FontWeight.w400),
            ),
            SizedBox(height: 6.h),
            ReusableText(
              text: "Discount: \$${invoice.discount}",
              style: appStyle(14, AppColors.kDark, FontWeight.w400),
            ),
            SizedBox(height: 6.h),
            ReusableText(
              text: "Tax: \$${invoice.tax}",
              style: appStyle(14, AppColors.kDark, FontWeight.w400),
            ),
            SizedBox(height: 6.h),
            ReusableText(
              text: "Total: \$${invoice.total}",
              style: appStyle(16, AppColors.kPrimary, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
