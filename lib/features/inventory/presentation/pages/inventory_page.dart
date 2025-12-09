import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/inventory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessories_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessory_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/category_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/category_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phone_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phones_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/supplier_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/supplier_page.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});
  final InventoryController controller = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.kBg,
        appBar: AppBar(
          centerTitle: true,
          title: ReusableText(
            text: 'Inventory Management',
            style: appStyle(18, AppColors.kWhite, FontWeight.bold),
          ),
          backgroundColor: AppColors.kPrimary,
          bottom: TabBar(
            controller: controller.tabController,
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
          controller: controller.tabController,
          children: [
            PhonesPage(),
            AccessoryPage(),
            CategoryPage(),
            SupplierPage(),
          ],
        ),
        floatingActionButton: Obx(
          () {
            return FloatingActionButton.extended(
              backgroundColor: AppColors.kPrimary,
              label: Row(
                children: [
                  const Icon(Icons.add_circle_outlined, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    _getFabText(controller.selectedIndex.value),
                    style: appStyle(14, Colors.white, FontWeight.w600),
                  ),
                ],
              ),
              onPressed: () {
                _openSheet(context, controller.selectedIndex.value);
              },
            );
          },
        ),
      ),
    );
  }

  String _getFabText(int index) {
    switch (index) {
      case 0:
        return "Add new phone";
      case 1:
        return "Add new accessory";
      case 2:
        return "Add new category";
      case 3:
        return "Add new supplier";
      default:
        return "";
    }
  }

  // BottomSheet Handler
  void _openSheet(BuildContext context, int index) {
    switch (index) {
      case 0:
        openPhoneFormSheet(context);
        break;
      case 1:
        openCreateAccessorySheet(context);
        break;
      case 2:
        openCreateCategorySheet(context);
        break;
      case 3:
        openCreateSupplierSheet(context);
        break;
    }
  }

  void openPhoneFormSheet(BuildContext context, {Phone? phone}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => PhoneFormBottomSheet(phone: phone),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  void openCreateAccessorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const AccessoryFormBottomSheet(),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  Future<void> openCreateCategorySheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CategoryFormBottomSheet(),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  Future<void> openCreateSupplierSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SupplierFormBottomSheet(),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }
}
