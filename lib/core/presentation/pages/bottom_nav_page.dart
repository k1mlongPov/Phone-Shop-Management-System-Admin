import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/presentation/controllers/bottom_nav_controller.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customers_page.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/inventory_page.dart';
import 'package:phone_management_system_admin/features/sales/presentation/pages/sales_page.dart';
import 'package:phone_management_system_admin/features/settings/presentation/pages/settings_page.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late final BottomNavController _navC;
  final PageStorageBucket _bucket = PageStorageBucket();
  final _dashboardKey = const PageStorageKey('dashboard');
  final _inventoryKey = const PageStorageKey('inventory');
  final _ordersKey = const PageStorageKey('orders');
  final _customersKey = const PageStorageKey('customers');
  final _settingsKey = const PageStorageKey('settings');

  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _navC = Get.find<BottomNavController>();
    _pages = [
      DashboardPage(key: _dashboardKey),
      InventoryPage(key: _inventoryKey),
      SalePage(key: _ordersKey),
      CustomersPage(key: _customersKey),
      SettingsPage(key: _settingsKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kBg,
        body: Obx(
          () {
            final idx = _navC.currentIndex.value;
            return PageStorage(
              bucket: _bucket,
              child: IndexedStack(
                index: idx,
                children: _pages,
              ),
            );
          },
        ),
        bottomNavigationBar: Obx(
          () {
            final index = _navC.currentIndex.value;
            return Container(
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: index,
                onTap: (i) {
                  _navC.changeIndex(i);
                  if (i == 2) _navC.clearOrdersBadge();
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.kWhite,
                unselectedItemColor: AppColors.kWhite.withOpacity(.4),
                showUnselectedLabels: true,
                backgroundColor: AppColors.kPrimary,
                selectedLabelStyle: appStyle(
                  12,
                  AppColors.kWhite,
                  FontWeight.w600,
                ),
                unselectedLabelStyle: appStyle(
                  12,
                  AppColors.kWhite.withOpacity(.6),
                  FontWeight.w600,
                ),
                elevation: 0,
                items: [
                  _buildItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    activeIcon: Icons.dashboard,
                  ),
                  _buildItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Inventory',
                    activeIcon: Icons.inventory_2,
                  ),
                  _buildItemWithBadge(
                    icon: Icons.receipt_long_outlined,
                    label: 'Sales',
                    activeIcon: Icons.receipt_long,
                    badgeCount: _navC.ordersBadgeCount.value,
                  ),
                  _buildItem(
                    icon: Icons.person_search_outlined,
                    label: 'Customers',
                    activeIcon: Icons.person_search,
                  ),
                  _buildItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    activeIcon: Icons.settings,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    required IconData icon,
    required String label,
    required IconData activeIcon,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 20.sp),
      activeIcon: Icon(activeIcon, size: 22.sp),
      label: label,
    );
  }

  BottomNavigationBarItem _buildItemWithBadge({
    required IconData icon,
    required String label,
    required IconData activeIcon,
    required int badgeCount,
  }) {
    final hasBadge = badgeCount > 0;
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 20.sp),
          if (hasBadge)
            Positioned(
              right: -6.w,
              top: -6.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.kRed,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: TextStyle(
                    color: AppColors.kWhite,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      activeIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(activeIcon, size: 22.sp),
          if (hasBadge)
            Positioned(
              right: -6.w,
              top: -6.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.kRed,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: TextStyle(
                    color: AppColors.kWhite,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
