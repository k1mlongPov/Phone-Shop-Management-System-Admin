import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/shell/app_shell.dart';
import 'package:phone_management_system_admin/core/shell/app_shell_binding.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_binding.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/login_page.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/registration_page.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/splash_page.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customers_page.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_binding.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:phone_management_system_admin/features/inventory/bindings/inventory_binding.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/inventory_page.dart';
import 'package:phone_management_system_admin/features/orders/presentation/pages/orders_page.dart';
import 'package:phone_management_system_admin/features/settings/presentation/pages/settings_page.dart';

class AppPages {
  static const initial = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegistrationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.APPSHELL,
      page: () => const AppShell(),
      bindings: [
        AppShellBinding(),
        InventoryBinding(),
      ],
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.INVENTORY,
      page: () => const InventoryPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.ORDER,
      page: () => const OrdersPage(),
      // binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.CUSTOMER,
      page: () => const CustomersPage(),
      // binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => const SettingsPage(),
      // binding: ProductBinding(),
    ),
  ];
}
