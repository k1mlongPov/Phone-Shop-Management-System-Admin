import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/category_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';

class SubCategoryController extends GetxController {
  final ApiService api = Get.find<ApiService>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final RxMap<String, List<CategoryModel>> subcategoriesByParent =
      <String, List<CategoryModel>>{}.obs;

  final RxString activeParentId = ''.obs;
  final phoneParentId = '68f08df7f75a21c5fed27fb6';
  final accessoryParentId = '68f08df7f75a21c5fed27fc0';

  final Rx<CategorySortField> sortField = CategorySortField.createdAt.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxString query = ''.obs;

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();

    // When root categories arrive, auto-select the first one as active parent.
    ever<List<CategoryModel>>(categoryController.rootCategories, (list) {
      if (list.isNotEmpty && activeParentId.value.isEmpty) {
        final firstParentId = list.first.id ?? '';
        if (firstParentId.isNotEmpty) {
          setActiveParent(firstParentId);
        }
      }
    });

    // If rootCategories were already loaded before this controller
    if (categoryController.rootCategories.isNotEmpty &&
        activeParentId.value.isEmpty) {
      final firstParentId = categoryController.rootCategories.first.id ?? '';
      if (firstParentId.isNotEmpty) {
        Future.microtask(() => setActiveParent(firstParentId));
      }
    }
  }

  Future<void> fetchSubcategories(String parentId, {bool force = false}) async {
    if (parentId.isEmpty) return;

    // Avoid refetch if we already have data and not forced
    if (!force && subcategoriesByParent.containsKey(parentId)) return;

    try {
      isLoading.value = true;
      error.value = null;

      final res = await api.get(
        '/api/categories/sub/$parentId',
        query: {
          if (query.value.isNotEmpty) 'q': query.value,
          'sort_by': sortField.value.backendKey,
          'sort_order': sortOrder.value,
        },
      );

      final body = res.data as Map<String, dynamic>? ?? {};
      final list = (body['data'] as List?) ?? [];

      final parsed = list
          .map(
            (e) => CategoryModel.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      subcategoriesByParent[parentId] = parsed;
      subcategoriesByParent.refresh();
    } catch (e, st) {
      error.value = e.toString();
      debugPrint('SubCategoryController.fetchSubcategories ERROR: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSubcategories(String parentId, {bool force = false}) async {
    if (parentId.isEmpty) return;

    activeParentId.value = parentId;
    await fetchSubcategories(parentId, force: force);
  }

  void setActiveParent(String parentId) {
    if (parentId.isEmpty) return;
    if (activeParentId.value == parentId &&
        subcategoriesByParent.containsKey(parentId)) {
      // Same parent and already have data -> do nothing
      return;
    }
    activeParentId.value = parentId;
    fetchSubcategories(parentId, force: true);
  }

  Future<void> refetchSubcategories(String parentId) async {
    if (parentId.isEmpty) return;
    subcategoriesByParent.remove(parentId);
    await fetchSubcategories(parentId, force: true);
  }

  List<CategoryModel> getSubcategories(String parentId) {
    return subcategoriesByParent[parentId] ?? <CategoryModel>[];
  }

  void setQuery(String text) {
    query.value = text.trim();
    if (activeParentId.value.isNotEmpty) {
      fetchSubcategories(activeParentId.value, force: true);
    }
  }

  void setSortField(CategorySortField field) {
    if (sortField.value == field) {
      // Toggle asc/desc exactly like Phone/Accessory
      sortOrder.value = sortOrder.value == 'asc' ? 'desc' : 'asc';
    } else {
      sortField.value = field;
      sortOrder.value = 'asc';
    }

    if (activeParentId.value.isNotEmpty) {
      fetchSubcategories(activeParentId.value, force: true);
    }
  }

  void clearSort() {
    sortField.value = CategorySortField.createdAt;
    sortOrder.value = 'desc';
    if (activeParentId.value.isNotEmpty) {
      fetchSubcategories(activeParentId.value, force: true);
    }
  }

  List<CategoryModel> getSubcategoriesFor(String parentId) {
    return subcategoriesByParent[parentId] ?? <CategoryModel>[];
  }

  Future<void> fetchForType(String type, {bool force = false}) async {
    final parent = categoryController.rootCategories.firstWhereOrNull(
      (c) => (c.name ?? '').toLowerCase().contains(type.toLowerCase()),
    );

    if (parent != null) {
      // FIX: Set active parent
      activeParentId.value = parent.id!;

      // Fetch subcategories for this parent
      await fetchSubcategories(parent.id!, force: force);
    }
  }
}
