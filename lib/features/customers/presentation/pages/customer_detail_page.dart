import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customer_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/customer_info_section.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/customer_profile_card.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/customer_purchase_history.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer customer; // initial snapshot
  final _ctrl = Get.find<CustomersController>();

  CustomerDetailPage({super.key, required this.customer});

  Future<dynamic> openUpdatedCutomerFormSheet(BuildContext context,
      {Customer? customer}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CustomerFormBottomSheet(customer: customer),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        title: ReusableText(
          text: "Customer Details",
          style: appStyle(16, AppColors.kDark, FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: AppColors.kWhite,
      ),
      body: Obx(() {
        final latest = _ctrl.findCustomerById(customer.id!) ?? customer;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerProfileCard(
                customer: latest,
                onEdit: () async {
                  await openUpdatedCutomerFormSheet(context, customer: latest);
                },
              ),
              SizedBox(height: 20.h),
              CustomerInfoSection(customer: latest),
              SizedBox(height: 20.h),
              CustomerPurchaseHistory(customer: latest),
            ],
          ),
        );
      }),
    );
  }
}
