import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';

import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customer_form_bottom_sheet.dart';

class CustomerPickerBottomSheet extends StatelessWidget {
  final CustomersController c = Get.find<CustomersController>();

  CustomerPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            _header(),
            SizedBox(height: 16.h),
            _searchField(),
            SizedBox(height: 10.h),
            _addCustomerButton(),
            SizedBox(height: 12.h),
            Expanded(child: _customerList()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.kGray.withOpacity(.6),
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          ReusableText(
            text: "Select Customer",
            style: appStyle(16, AppColors.kDark, FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomTextField(
      prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
      hintText: "Search customer...",
      onChanged: (v) => c.search(v),
    );
  }

  Widget _addCustomerButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () async {
          final created = await Get.to(
            () => const Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: CustomerFormBottomSheet(),
              ),
            ),
            fullscreenDialog: true,
          );

          if (created != null) {
            c.loadTabData();
          }
        },
        icon: const Icon(Icons.add, color: AppColors.kPrimary),
        label: ReusableText(
          text: "Add New",
          style: appStyle(13, AppColors.kPrimary, FontWeight.w600),
        ),
      ),
    );
  }

  Widget _customerList() {
    return Obx(() {
      final query = c.searchQuery.value.toLowerCase().trim();

      final list = query.isEmpty
          ? c.customers
          : c.customers.where((cust) {
              final name = cust.name.toLowerCase();
              final phone = (cust.phone ?? "").toLowerCase();
              return name.contains(query) || phone.contains(query);
            }).toList();

      if (list.isEmpty) {
        return Center(
          child: ReusableText(
            text: "No customers found",
            style: appStyle(12, Colors.grey, FontWeight.normal),
          ),
        );
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final cust = list[i];
          return _tile(
            name: cust.name,
            phone: cust.phone ?? "No phone",
            email: cust.email,
            onTap: () => Get.back(result: cust),
          );
        },
      );
    });
  }

  Widget _tile({
    required String name,
    required String phone,
    String? email,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.kPrimary.withOpacity(0.12),
              child: const Icon(Icons.person, color: AppColors.kPrimary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: name,
                    style: appStyle(14, AppColors.kDark, FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text: "📞 $phone",
                    style:
                        appStyle(12, Colors.grey.shade700, FontWeight.normal),
                  ),
                  if (email != null && email.trim().isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    ReusableText(
                      text: "✉️ $email",
                      style:
                          appStyle(12, Colors.grey.shade700, FontWeight.normal),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
