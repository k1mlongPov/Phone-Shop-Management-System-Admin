import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/sales/logic/invoice_history_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/pages/invoice_detail_page.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class InvoiceHistoryPage extends StatelessWidget {
  final c = Get.find<InvoiceHistoryController>();

  InvoiceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
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
          text: 'Invoice History',
          style: appStyle(18, AppColors.kWhite, FontWeight.w600),
        ),
      ),
      body: Obx(
        () {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.invoices.isEmpty) {
            return Center(
              child: ReusableText(
                text: 'No invoices found.',
                style: appStyle(18, AppColors.kDark, FontWeight.w600),
              ),
            );
          }

          return ListView.separated(
            itemCount: c.invoices.length,
            separatorBuilder: (_, __) => Container(),
            itemBuilder: (_, i) {
              final inv = c.invoices[i];

              return Container(
                color: AppColors.kWhite,
                padding: EdgeInsets.all(8.r),
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: ListTile(
                  title: ReusableText(
                    text: '#${inv.invoiceNo}',
                    style: appStyle(16, AppColors.kDark, FontWeight.w500),
                  ),
                  subtitle: ReusableText(
                    text: "${inv.customerName} • \$${inv.total}",
                    style: appStyle(14, AppColors.kDark, FontWeight.w400),
                  ),
                  trailing: ReusableText(
                    text: "${inv.createdAt?.toLocal()}".split(".")[0],
                    style: appStyle(12, AppColors.kGray, FontWeight.w400),
                  ),
                  onTap: () {
                    Get.to(
                      () => InvoiceDetailPage(invoice: inv),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
