import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/data/supplier_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';

class SupplierController extends GetxController {
  final SupplierRepository repository;

  SupplierController({required this.repository});

  /// STATE
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString error = RxnString();

  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;

  /// no pagination for now
  @override
  void onInit() {
    super.onInit();
    fetchSuppliers();
  }

  // ---------------- FETCH -----------------

  Future<void> fetchSuppliers() async {
    try {
      isLoading.value = true;
      error.value = null;

      final list = await repository.fetchSuppliers();
      suppliers.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- CREATE -----------------

  Future<void> createSupplier(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;

      final created = await repository.create(payload);
      suppliers.add(created);

      Get.snackbar('Success', 'Supplier created successfully');
    } catch (e) {
      Get.snackbar('Create failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  // ---------------- UPDATE -----------------

  Future<bool> updateSupplier(String id, Map<String, dynamic> payload) async {
    try {
      final updated = await repository.updateSupplier(id, payload);

      final index = suppliers.indexWhere((s) => s.id == id);
      if (index != -1) suppliers[index] = updated;

      Get.snackbar('Success', 'Supplier updated');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  // ---------------- DELETE -----------------

  Future<bool> deleteSupplier(String id) async {
    try {
      await repository.deleteSupplier(id);

      suppliers.removeWhere((s) => s.id == id);
      Get.snackbar('Deleted', 'Supplier removed');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  SupplierModel? getById(String id) {
    return suppliers.firstWhereOrNull((s) => s.id == id);
  }
}
