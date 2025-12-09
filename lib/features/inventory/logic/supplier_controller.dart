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

  @override
  Future<void> refresh() async {
    await fetchSuppliers();
  }

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

  Future<SupplierModel?> createSupplier(Map<String, dynamic> payload) async {
    try {
      final created = await repository.create(payload);
      suppliers.add(created);
      return created;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  Future<SupplierModel?> updateSupplier(
      String id, Map<String, dynamic> payload) async {
    try {
      final updated = await repository.updateSupplier(id, payload);

      final index = suppliers.indexWhere((s) => s.id == id);
      if (index != -1) {
        suppliers[index] = updated;
        suppliers.refresh();
      }

      return updated;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  void updateLocal(SupplierModel updated) {
    final idx = suppliers.indexWhere((x) => x.id == updated.id);
    if (idx != -1) suppliers[idx] = updated;
  }

  Future<bool> deleteSupplier(String id) async {
    try {
      final ok = await repository.deleteSupplier(id);
      if (ok) {
        suppliers.removeWhere((s) => s.id == id);
        suppliers.refresh();
      }
      return ok;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  SupplierModel? getById(String id) {
    return suppliers.firstWhereOrNull((s) => s.id == id);
  }
}
