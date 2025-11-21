import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/data/accessory_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/accessory_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';

class AccessoryController extends GetxController {
  final AccessoryRepository repository;
  AccessoryController({required this.repository});

  // STATE
  final RxList<Accessory> accessories = <Accessory>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString error = RxnString();

  // Paging
  final RxInt page = 1.obs;
  final RxInt pages = 1.obs;
  final RxInt total = 0.obs;
  final RxInt limit = 12.obs;

  // Filters / sort
  final RxString query = ''.obs;

  final RxString selectedCategoryId = ''.obs;

  final Rx<AccessorySortField> sortField = AccessorySortField.createdAt.obs;
  final RxString sortOrder = 'asc'.obs;
  final RxString sortBy = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccessories(reset: true);
  }

  // ----------------- actions -----------------

  void setQuery(String q) {
    query.value = q;
    fetchAccessories(reset: true);
  }

  /// set server sort key (ex: 'price_asc' or 'name' etc)
  void setSortField(AccessorySortField field) {
    if (sortField.value == field) {
      // user clicked same sort -> toggle asc/desc
      sortOrder.value = sortOrder.value == 'asc' ? 'desc' : 'asc';
    } else {
      // switch to new field & reset to ascending
      sortField.value = field;
      sortOrder.value = 'asc';
    }

    // backend sort key produced from enum extension
    sortBy.value = field.backendKey(sortOrder.value);

    fetchAccessories(reset: true);
  }

  void clearSort() {
    sortField.value = AccessorySortField.createdAt;
    sortOrder.value = 'asc';
    sortBy.value = '';
    fetchAccessories(reset: true);
  }

  void setCategoryFilter(String? id) {
    selectedCategoryId.value = (id ?? '').isEmpty ? '' : id!;
    fetchAccessories(reset: true);
  }

  // ----------------- fetch list -----------------
  Future<void> fetchAccessories({bool reset = false}) async {
    if (reset) {
      page.value = 1;
      pages.value = 1;
      total.value = 0;
      accessories.clear();
      error.value = null;
    }

    if (isLoading.value || isLoadingMore.value) return;

    try {
      if (page.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final res = await repository.fetchAccessories(
        page: page.value,
        limit: limit.value,
        q: query.value.isEmpty ? null : query.value,
        sortBy: sortBy.value.isEmpty ? null : sortBy.value,
        categoryId:
            selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
      );

      final List<Accessory> fetched =
          (res['accessories'] as List).cast<Accessory>();
      final fetchedPage = res['page'] as int? ?? page.value;
      final fetchedPages = res['pages'] as int? ?? 1;
      final fetchedTotal = res['total'] as int? ?? fetched.length;

      if (reset) {
        accessories.assignAll(fetched);
      } else {
        accessories.addAll(fetched);
      }

      page.value = fetchedPage;
      pages.value = fetchedPages;
      total.value = fetchedTotal;
      error.value = null;
    } catch (e, st) {
      error.value = e.toString();
      print('AccessoryController.fetchAccessories error: $e\n$st');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // pull to refresh
  @override
  Future<void> refresh() async {
    page.value = 1;
    await fetchAccessories(reset: true);
  }

  // infinite scroll
  Future<void> loadMore() async {
    if (isLoadingMore.value) return;
    if (page.value >= pages.value) return;

    page.value = page.value + 1;
    await fetchAccessories(reset: false);
  }

  // ----------------- single item -----------------
  Future<Accessory?> fetchAccessoryById(String id) async {
    try {
      isLoading.value = true;
      final acc = await repository.getAccessory(id);
      // update cache (insert or replace)
      final idx = accessories.indexWhere((a) => a.id == acc.id);
      if (idx == -1 && acc.id != null) {
        accessories.insert(0, acc);
      } else if (idx != -1) {
        accessories[idx] = acc;
      }
      return acc;
    } catch (e) {
      print('AccessoryController.fetchAccessoryById error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------- delete / restock -----------------
  Future<void> deleteAccessory(String id) async {
    try {
      await repository.deleteAccessory(id);
      accessories.removeWhere((a) => a.id == id);
      Get.snackbar('Deleted', 'Accessory deleted');
    } catch (e) {
      Get.snackbar('Delete failed', e.toString());
    }
  }

  Future<void> restockAccessory({
    required String id,
    required int quantity,
    String? note,
  }) async {
    try {
      final updated =
          await repository.restock(id: id, quantity: quantity, note: note);
      final idx = accessories.indexWhere((a) => a.id == id);
      if (idx != -1) {
        accessories[idx] = updated;
      }
      Get.snackbar('Restocked', 'Stock updated');
    } catch (e) {
      Get.snackbar('Restock failed', e.toString());
    }
  }
}
