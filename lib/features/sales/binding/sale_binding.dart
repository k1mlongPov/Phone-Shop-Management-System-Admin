import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/sales/data/invoice_history_repository.dart';
import 'package:phone_management_system_admin/features/sales/data/sale_repository.dart';
import 'package:phone_management_system_admin/features/sales/logic/invoice_history_controller.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';

class SaleBinding extends Bindings {
  @override
  void dependencies() {
    final ApiService api = Get.find<ApiService>();

    Get.lazyPut<SaleRepository>(
      () => SaleRepository(api: api),
      fenix: true,
    );
    Get.lazyPut<InvoiceHistoryRepository>(
      () => InvoiceHistoryRepository(api: api),
      fenix: true,
    );

    Get.lazyPut<SaleController>(
      () => SaleController(
        repo: Get.find<SaleRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<InvoiceHistoryController>(
      () => InvoiceHistoryController(
        repo: Get.find<InvoiceHistoryRepository>(),
      ),
      fenix: true,
    );
  }
}
