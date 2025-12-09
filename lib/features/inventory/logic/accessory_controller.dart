import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_management_system_admin/features/inventory/data/accessory_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/accessory_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';

class AttributeField {
  String key;
  String value;
  AttributeField({this.key = "", this.value = ""});
}

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

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final brandController = TextEditingController();

  final purchasePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();

  final currencyController = TextEditingController(text: "USD");

  final categoryId = ''.obs;
  final subcategoryId = ''.obs;
  final supplierId = ''.obs;

  final stockController = TextEditingController(text: "0");

  final compatibilityController = TextEditingController();

  // ATTRIBUTES
  RxList<AttributeField> attributes = <AttributeField>[].obs;
  void addAttribute() => attributes.add(AttributeField());
  void removeAttribute(int i) => attributes.removeAt(i);

  Map<String, dynamic> buildAttributes() {
    final map = <String, dynamic>{};
    for (var a in attributes) {
      if (a.key.trim().isNotEmpty) {
        map[a.key] = a.value;
      }
    }
    return map;
  }

  // IMAGES
  RxList<XFile> pickedImages = <XFile>[].obs;
  final ImagePicker picker = ImagePicker();

  Future pickImages() async {
    final imgs = await picker.pickMultiImage();
    if (imgs.isNotEmpty) pickedImages.addAll(imgs);
  }

  void removeImage(int i) => pickedImages.removeAt(i);

  @override
  void onInit() {
    super.onInit();
    fetchAccessories(reset: true);
  }

  void setQuery(String q) {
    query.value = q;
    fetchAccessories(reset: true);
  }

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
      debugPrint('AccessoryController.fetchAccessories error: $e\n$st');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

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
      debugPrint('AccessoryController.fetchAccessoryById error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    page.value = 1;
    await fetchAccessories(reset: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value) return;
    if (page.value >= pages.value) return;

    page.value = page.value + 1;
    await fetchAccessories(reset: false);
  }

  Future<bool> createAccessory({
    required String name,
    required String type,
    String? brand,
    required double purchasePrice,
    required double sellingPrice,
    required String currency,
    required String categoryId,
    required String supplierId,
    Map<String, dynamic>? attributes,
    List<String>? compatibility,
    List<String>? imagePaths,
    int stock = 0,
    int lowStockThreshold = 5,
  }) async {
    try {
      final created = await repository.createAccessory(
        name: name,
        type: type,
        brand: brand,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        currency: currency,
        categoryId: categoryId,
        supplierId: supplierId,
        attributes: attributes,
        compatibility: compatibility,
        imagePaths: imagePaths,
        stock: stock,
        lowStockThreshold: lowStockThreshold,
      );

      accessories.insert(0, created);
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  Future<bool> updateAccessory(
    String id, {
    required String name,
    required String type,
    String? brand,
    required double purchasePrice,
    required double sellingPrice,
    required String currency,
    required String categoryId,
    required String supplierId,
    Map<String, dynamic>? attributes,
    List<String>? compatibility,
    List<String>? imagePaths, // new only
    int? stock,
    int? lowStockThreshold,
  }) async {
    try {
      final updated = await repository.updateAccessory(
        id: id,
        name: name,
        type: type,
        brand: brand,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        currency: currency,
        categoryId: categoryId,
        supplierId: supplierId,
        attributes: attributes,
        compatibility: compatibility,
        imagePaths: imagePaths,
        stock: stock,
        lowStockThreshold: lowStockThreshold,
      );

      // replace local state
      final index = accessories.indexWhere((a) => a.id == id);
      if (index != -1) {
        accessories[index] = updated;
      }
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  void updateLocal(Accessory updated) {
    final idx = accessories.indexWhere((x) => x.id == updated.id);
    if (idx != -1) accessories[idx] = updated;
  }

  Future<void> deleteAccessory(String id) async {
    try {
      await repository.deleteAccessory(id);
      accessories.removeWhere((a) => a.id == id);
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
