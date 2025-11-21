import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessories_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/category_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phones_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/supplier_page.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ReusableText(
            text: 'Inventory Management',
            style: appStyle(18, AppColors.kWhite, FontWeight.bold),
          ),
          backgroundColor: AppColors.kPrimary,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Phones'),
              Tab(text: 'Accessories'),
              Tab(text: 'Categories'),
              Tab(text: 'Suppliers'),
            ],
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: appStyle(14, AppColors.kWhite, FontWeight.w600),
            unselectedLabelStyle: appStyle(
              14,
              AppColors.kWhite.withOpacity(.7),
              FontWeight.w600,
            ),
            dividerHeight: 3,
            dividerColor: AppColors.kPrimary,
            indicatorColor: AppColors.kWhite,
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PhonesPage(),
            AccessoryPage(),
            CategoryPage(),
            SupplierPage(),
          ],
        ),
      ),
    );
  }
}
