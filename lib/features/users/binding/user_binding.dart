import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/users/data/user_repository.dart';
import 'package:phone_management_system_admin/features/users/logic/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    final ApiService api = Get.find<ApiService>();

    Get.lazyPut<UsersRepository>(
      () => UsersRepository(api: api),
      fenix: true,
    );

    Get.lazyPut<UsersController>(
      () => UsersController(repo: Get.find<UsersRepository>()),
      fenix: true,
    );
  }
}
