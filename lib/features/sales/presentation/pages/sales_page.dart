import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/pages/invoice_history_page.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/payment_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/sale_customer_selector.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/sale_line_list.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/sale_totals_section.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/sale_checkout_button.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final SaleController saleCtrl = Get.find<SaleController>();
  final PhoneController phoneCtrl = Get.find<PhoneController>();
  final AccessoryController accCtrl = Get.find<AccessoryController>();

  final ScrollController scrollCtrl = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBg,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 1,
        title: ReusableText(
          text: "New Sale",
          style: appStyle(16, AppColors.kWhite, FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => InvoiceHistoryPage()),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              child: ReusableText(
                text: 'See invoices',
                style: appStyle(13, AppColors.kWhite, FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollCtrl,
        child: Column(
          children: [
            SaleCustomerSelector(controller: saleCtrl),

            SaleLineList(
              saleCtrl: saleCtrl,
              phoneCtrl: phoneCtrl,
              accCtrl: accCtrl,
              listKey: listKey,
            ),

            _addLineButton(),

            // totals section
            SaleTotalsSection(controller: saleCtrl),

            SizedBox(height: 80.h),
          ],
        ),
      ),
      floatingActionButton: SaleCheckoutButton(
        controller: saleCtrl,
        onPay: (saleCtrl) async {
          final invoice = await Get.bottomSheet(
            PaymentBottomSheet(controller: saleCtrl),
            isScrollControlled: true,
          );

          if (invoice != null) {
            Get.snackbar("Success", "Sale Completed");
          }
        },
      ),
    );
  }

  /// Add Line button lives here (not extracted to its own file)
  Widget _addLineButton() {
    return GestureDetector(
      onTap: () {
        // 1) add new empty line to controller
        saleCtrl.addLine();

        // 2) animate it into AnimatedList
        final index = saleCtrl.items.length - 1;
        listKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 250),
        );

        // 3) auto scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollCtrl.hasClients) {
            scrollCtrl.animateTo(
              scrollCtrl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: AppColors.kPrimary),
            SizedBox(width: 6.w),
            ReusableText(
              text: "Add Item",
              style: appStyle(14, AppColors.kPrimary, FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
