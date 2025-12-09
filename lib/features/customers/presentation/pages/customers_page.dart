import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customer_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/customer_tab_bar.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/customer_tab_content.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomersPage extends StatelessWidget {
  CustomersPage({super.key});

  final CustomersController c = Get.find<CustomersController>();

  void openCreateCustomerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CustomerFormBottomSheet(),
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
      backgroundColor: AppColors.kBg,
      appBar: AppBar(
        title: ReusableText(
          text: "Customers & Users",
          style: appStyle(16, AppColors.kDark, FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: AppColors.kWhite,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          CustomerTabBar(c: c),
          Expanded(child: CustomerTabContent(c: c)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'customers',
        backgroundColor: AppColors.kPrimary,
        onPressed: () => openCreateCustomerSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomTextField(
        hintText: "Search by name, phone, email...",
        prefixIcon: const Icon(Icons.search, size: 18),
        onChanged: c.search,
      ),
    );
  }
}
