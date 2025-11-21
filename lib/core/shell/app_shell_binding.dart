import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/inventory_controller.dart';
import 'package:phone_management_system_admin/features/orders/logic/orders_controller.dart';
import 'package:phone_management_system_admin/features/settings/logic/settings_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent only if needed
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<InventoryController>(
      () => InventoryController(),
      fenix: true,
    );
    Get.lazyPut<OrdersController>(() => OrdersController(), fenix: true);
    Get.lazyPut<CustomersController>(() => CustomersController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
