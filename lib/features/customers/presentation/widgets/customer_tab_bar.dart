import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

class CustomerTabBar extends StatelessWidget {
  final CustomersController c;

  const CustomerTabBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 3;

          return TabBar(
            controller: c.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.kPrimary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.kDark,
            labelStyle: appStyle(14, AppColors.kWhite, FontWeight.w500),
            dividerColor: Colors.transparent,
            tabs: [
              SizedBox(width: tabWidth, child: const Tab(text: "Customers")),
              SizedBox(width: tabWidth, child: const Tab(text: "Staff")),
              SizedBox(width: tabWidth, child: const Tab(text: "Admins")),
            ],
          );
        },
      ),
    );
  }
}
