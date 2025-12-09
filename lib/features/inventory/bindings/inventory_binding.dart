import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/inventory/data/accessory_repository.dart';
import 'package:phone_management_system_admin/features/inventory/data/category_repository.dart';
import 'package:phone_management_system_admin/features/inventory/data/phone_repository.dart';
import 'package:phone_management_system_admin/features/inventory/data/restock_repository.dart';
import 'package:phone_management_system_admin/features/inventory/data/supplier_repository.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/inventory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    // Shared ApiService (created in InitialBinding)
    final ApiService api = Get.find<ApiService>();
    final LocalStorageService storage = Get.find<LocalStorageService>();

    // Repositories (use fenix so they can be recreated)
    Get.lazyPut<PhoneRepository>(
      () => PhoneRepository(api: api, storage: storage),
      fenix: true,
    );
    Get.lazyPut<AccessoryRepository>(
      () => AccessoryRepository(api: api),
      fenix: true,
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(api: api),
      fenix: true,
    );
    Get.lazyPut<SupplierRepository>(
      () => SupplierRepository(api: api),
      fenix: true,
    );
    Get.lazyPut<RestockRepository>(
      () => RestockRepository(api: api),
      fenix: true,
    );

    // Controllers (each uses its repository)
    Get.lazyPut<PhoneController>(
      () => PhoneController(
        repository: Get.find<PhoneRepository>(),
        storage: storage,
      ),
      fenix: true,
    );
    Get.lazyPut<AccessoryController>(
      () => AccessoryController(repository: Get.find<AccessoryRepository>()),
      fenix: true,
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
      fenix: true,
    );
    Get.lazyPut<SupplierController>(
      () => SupplierController(repository: Get.find<SupplierRepository>()),
      fenix: true,
    );
    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(),
      fenix: true,
    );
    Get.lazyPut<InventoryController>(
      () => InventoryController(),
      fenix: true,
    );
  }
}
