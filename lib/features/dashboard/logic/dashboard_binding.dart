import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
