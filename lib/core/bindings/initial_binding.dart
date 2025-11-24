import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/auth/data/auth_repository.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';
import 'package:phone_management_system_admin/shared/constants/app_config.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1) Local storage - register first
    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);

    // 2) ApiService - depends on LocalStorageService
    Get.put<ApiService>(
      ApiService(
        baseUrl: AppConfig.apiBaseUrl, // adjust your config
        storage: Get.find<LocalStorageService>(),
      ),
      permanent: true,
    );

    // 3) Auth repository + controller (example)
    Get.put<AuthRepository>(
      AuthRepository(
          api: Get.find<ApiService>(),
          storage: Get.find<LocalStorageService>()),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(
        repository: Get.find<AuthRepository>(),
        storage: Get.find<LocalStorageService>(),
      ),
      permanent: true,
    );
  }
}
