import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/shell/app_shell.dart';
import 'package:phone_management_system_admin/core/shell/app_shell_binding.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_binding.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/login_page.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/registration_page.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/splash_page.dart';
import 'package:phone_management_system_admin/features/auth/presentation/pages/verification_page.dart';
import 'package:phone_management_system_admin/features/customers/binding/customer_binding.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customers_page.dart';
import 'package:phone_management_system_admin/features/dashboard/binding/dashboard_binding.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:phone_management_system_admin/features/inventory/bindings/inventory_binding.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessories_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessory_detail_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/inventory_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phone_detail_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phones_page.dart';
import 'package:phone_management_system_admin/features/sales/binding/sale_binding.dart';
import 'package:phone_management_system_admin/features/sales/presentation/pages/sales_page.dart';
import 'package:phone_management_system_admin/features/settings/presentation/pages/settings_page.dart';
import 'package:phone_management_system_admin/features/users/binding/user_binding.dart';

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
      name: Routes.VERIFY,
      page: () => const VerificationPage(),
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
        DashboardBinding(),
        InventoryBinding(),
        SaleBinding(),
        CustomerBinding(),
        UserBinding(),
      ],
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.INVENTORY,
      page: () => InventoryPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.PHONE,
      page: () => PhonesPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.PHONE_DETAIL,
      page: () => const PhoneDetailPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.ACCESSORY,
      page: () => AccessoryPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.ACCESSORY_DETAIL,
      page: () => const AccessoryDetailPage(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.ORDER,
      page: () => const SalePage(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: Routes.CUSTOMER,
      page: () => CustomersPage(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => const SettingsPage(),
      // binding: ProductBinding(),
    ),
  ];
}
