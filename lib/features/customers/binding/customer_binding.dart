import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/customers/data/customer_repository.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    final ApiService api = Get.find<ApiService>();

    Get.lazyPut<CustomersRepository>(
      () => CustomersRepository(api: api),
      fenix: true,
    );

    Get.lazyPut<CustomersController>(
      () => CustomersController(repo: Get.find<CustomersRepository>()),
      fenix: true,
    );
  }
}
