import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/inventory/data/phone_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/phone_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';

class PhoneController extends GetxController {
  final PhoneRepository repository;
  final LocalStorageService storage;

  PhoneController({required this.repository, required this.storage});

  // State
  final RxList<Phone> phones = <Phone>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final page = 1.obs;
  final pages = 1.obs;
  final total = 0.obs;
  final query = ''.obs;
  final limit = 12.obs;
  final error = RxnString();

  final Rxn<Phone> selectedPhone = Rxn<Phone>();

  final Rx<PhoneSortField> sortField =
      Rx<PhoneSortField>(PhoneSortField.createdAt);
  final RxString sortBy = ''.obs;
  final RxString sortOrder = 'asc'.obs;
  final RxString selectedCategoryId = ''.obs;

  String get activeSortKey => sortBy.value;
  final Duration searchDebounce = const Duration(milliseconds: 450);

  @override
  void onInit() {
    super.onInit();
    debounce<String>(query, (_) => fetchPhones(reset: true),
        time: const Duration(milliseconds: 600));
    debounce<String>(query, (_) {
      refresh();
    }, time: searchDebounce);
    fetchPhones(reset: true);
  }

  void setQuery(String q) => query.value = q;

  void setSortField(PhoneSortField field) {
    if (sortField.value == field) {
      if (field == PhoneSortField.price ||
          field == PhoneSortField.stock ||
          field == PhoneSortField.createdAt) {
        sortOrder.value = sortOrder.value == 'asc' ? 'desc' : 'asc';
      } else {
        sortOrder.value = 'asc';
      }
    } else {
      sortField.value = field;
      sortOrder.value = 'asc';
    }

    String serverKey;
    switch (field) {
      case PhoneSortField.price:
        serverKey = sortOrder.value == 'asc' ? 'price_asc' : 'price_desc';
        break;
      case PhoneSortField.stock:
        serverKey = sortOrder.value == 'asc' ? 'stock_asc' : 'stock_desc';
        break;
      case PhoneSortField.createdAt:
        // backend has 'latest' (createdAt -1) and 'oldest' (createdAt 1)
        serverKey = sortOrder.value == 'asc' ? 'oldest' : 'latest';
        break;
      case PhoneSortField.brand:
      case PhoneSortField.model:
        // backend expects 'name' to sort by brand/model (no desc key provided)
        serverKey = 'name';
        break;
      case PhoneSortField.none:
      default:
        serverKey = '';
    }

    sortBy.value = serverKey;
    fetchPhones(reset: true);
  }

  void setSortKey(String serverKey) {
    sortBy.value = serverKey;
    // keep sortField/sortOrder in sync if possible (best-effort)
    if (serverKey.contains('price')) {
      sortField.value = PhoneSortField.price;
      sortOrder.value = serverKey.endsWith('_desc') ? 'desc' : 'asc';
    } else if (serverKey.contains('stock')) {
      sortField.value = PhoneSortField.stock;
      sortOrder.value = serverKey.endsWith('_desc') ? 'desc' : 'asc';
    } else if (serverKey == 'latest' || serverKey == 'oldest') {
      sortField.value = PhoneSortField.createdAt;
      sortOrder.value = (serverKey == 'oldest') ? 'asc' : 'desc';
    } else if (serverKey == 'name') {
      // ambiguous between brand/model — leave as-is
      sortField.value = PhoneSortField.brand;
      sortOrder.value = 'asc';
    } else {
      sortField.value = PhoneSortField.none;
      sortOrder.value = 'asc';
    }

    fetchPhones(reset: true);
  }

  void clearSort() {
    sortField.value = PhoneSortField.none;
    sortBy.value = '';
    sortOrder.value = 'asc';
    fetchPhones(reset: true);
  }

  void setCategoryFilter(String? categoryId) {
    // allow clearing by passing null or empty string
    selectedCategoryId.value = categoryId ?? '';
    fetchPhones(reset: true);
  }

  @override
  Future<void> refresh() async {
    page.value = 1;
    await fetchPhones(reset: true);
  }

  Future<void> fetchPhones({bool reset = false}) async {
    if (reset) {
      page.value = 1;
      pages.value = 1;
      phones.clear();
      error.value = null;
    }

    if (isLoading.value || isLoadingMore.value) return;

    try {
      if (page.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final resp = await repository.fetchPhones(
        page: page.value,
        limit: limit.value,
        q: query.value.isEmpty ? null : query.value,
        // IMPORTANT: use the server-key string you stored in sortBy.value
        // (setSortField writes the correct server keys like 'price_asc', 'name', etc.)
        sortBy: sortBy.value.isEmpty ? null : sortBy.value,
        sortOrder: sortOrder.value,
        categoryId:
            selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
      );

      final fetched = (resp['phones'] as List).cast<Phone>();
      final fetchedPage = resp['page'] as int? ?? page.value;
      final fetchedPages = resp['pages'] as int? ?? 1;
      final fetchedTotal = resp['total'] as int? ?? fetched.length;
      print('fetchPhones query -> $query');

      if (reset) {
        phones.assignAll(fetched);
      } else {
        phones.addAll(fetched);
      }

      page.value = fetchedPage;
      pages.value = fetchedPages;
      total.value = fetchedTotal;
      error.value = null;
    } catch (e, st) {
      error.value = e.toString();
      print('PhoneController.fetchPhones error: $e\n$st');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<Phone?> fetchPhoneById(String id,
      {bool updateList = true, bool setSelected = true}) async {
    try {
      isLoading.value = true;

      final p = await repository.getPhoneById(id);

      if (updateList) {
        // Update phones list if it already exists
        final idx = phones.indexWhere((e) => e.id == id);
        if (idx != -1) {
          phones[idx] = p;
        } else {
          phones.add(p);
        }
        phones.refresh();
      }

      if (setSelected) {
        selectedPhone.value = p;
      }

      return p;
    } catch (e, st) {
      error.value = e.toString();
      print('fetchPhoneById ERROR: $e\n$st');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (page.value >= pages.value) return;
    page.value = page.value + 1;
    await fetchPhones(reset: false);
  }

  void removeLocalById(String id) {
    phones.removeWhere((p) {
      try {
        // typed id check (most models include .id)
        final typedId = (p).id;
        if (typedId != null && typedId.toString() == id) return true;

        // try typed sku if present
        final dynamicP = p as dynamic;
        final skuTyped = dynamicP.sku;
        if (skuTyped != null && skuTyped.toString() == id) return true;

        // fallback to toJson map if available
        final map = (p as dynamic).toJson?.call();
        if (map != null) {
          final sku = map['sku'] ?? map['id'];
          if (sku != null && sku.toString() == id) return true;
        }
      } catch (_) {
        // in case of any runtime exceptions, fallback to id compare if available
        try {
          return ((p as dynamic).id?.toString() ?? '') == id;
        } catch (_) {
          return false;
        }
      }
      return false;
    });
  }

  Future<bool> createPhone(
      Map<String, dynamic> input, List<XFile> pickedImages) async {
    try {
      final phone = await repository.createPhone(
        brand: input['brand'],
        model: input['model'],
        purchasePrice: input['purchasePrice'],
        sellingPrice: input['sellingPrice'],
        currency: input['currency'],
        categoryId: input['category'],
        supplierId: input['supplier'],
        specs: input['specs'],
        variants: input['variants'],
        imagePaths: pickedImages.isEmpty
            ? null
            : pickedImages.map((f) => f.path).toList(),
      );

      phones.insert(0, phone);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePhone(
    String id,
    Map<String, dynamic> input,
    List<XFile> pickedImages,
  ) async {
    try {
      final updated = await repository.updatePhone(
        id: id,
        brand: input['brand'],
        model: input['model'],
        purchasePrice: input['purchasePrice'],
        sellingPrice: input['sellingPrice'],
        currency: input['currency'],
        categoryId: input['category'],
        supplierId: input['supplier'],
        specs: input['specs'],
        variants: input['variants'],
        imagePaths: pickedImages.isEmpty
            ? null
            : pickedImages.map((f) => f.path).toList(),
      );

      // Update local list
      final index = phones.indexWhere((p) => p.id == id);
      if (index != -1) phones[index] = updated;

      return true;
    } catch (e) {
      return false;
    }
  }

  void updateLocal(Phone updated) {
    final idx = phones.indexWhere((x) => x.id == updated.id);
    if (idx != -1) phones[idx] = updated;
  }

  Future<void> deletePhone(String id) async {
    try {
      await repository.deletePhone(id);
      removeLocalById(id);
    } catch (e) {
      print('PhoneController.deletePhone error: $e');
      rethrow;
    }
  }

  Future<Phone> getPhone(String id) => repository.getPhoneById(id);
}
