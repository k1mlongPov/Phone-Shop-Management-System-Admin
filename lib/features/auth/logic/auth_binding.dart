import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/auth/data/auth_repository.dart';
import 'package:phone_management_system_admin/features/auth/logic/switch_controller.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
// Get existing core services from InitialBinding
    final api = Get.find<ApiService>();
    final storage = Get.find<LocalStorageService>();

// Repository depends on ApiService & LocalStorageService
    Get.lazyPut<AuthRepository>(
        () => AuthRepository(api: api, storage: storage));

// AuthController depends on AuthRepository
    Get.lazyPut<AuthController>(
        () => AuthController(repository: Get.find(), storage: storage));

    Get.lazyPut<SwitchController>(() => SwitchController());
  }
}
