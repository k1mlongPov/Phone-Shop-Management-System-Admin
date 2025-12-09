import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final ApiService api = Get.find<ApiService>();
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepository(api: api),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(repo: Get.find<DashboardRepository>()),
      fenix: true,
    );
  }
}
