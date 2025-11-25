import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:phone_management_system_admin/features/inventory/data/category_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/category_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository;
  CategoryController({required this.repository});

  final RxList<CategoryModel> rootCategories = <CategoryModel>[].obs;
  final RxList<CategoryModel> subcategories = <CategoryModel>[].obs;

  final RxMap<String, String> _parentNameToId = <String, String>{}.obs;

  final Rx<CategorySortField> sortField = CategorySortField.createdAt.obs;
  final RxString sortOrder = 'asc'.obs;
  final RxString sortBy = ''.obs;
  final RxString query = ''.obs;

  final RxBool isLoadingRoot = false.obs;
  final RxBool isLoadingSub = false.obs;
  final RxBool isLoadingMoreInternal = false.obs;

  final RxString currentParentId = ''.obs;

  final RxnString errorInternal = RxnString();

  final RxInt subPage = 1.obs;
  int subPages = 1;
  int subLimit = 100;

  final RxString subQuery = ''.obs;
  final RxString subSortBy = ''.obs;
  final RxString subSortOrder = 'asc'.obs;

  int page = 1;
  int pages = 1;
  int limit = 20;

  @override
  void onInit() {
    super.onInit();
    loadRootCategories();
  }

  void setQuery(String q) {
    query.value = q;
    fetchCategories(reset: true);
  }

  Future<void> fetchCategories({bool reset = false}) async {
    if (reset) {
      page = 1;
      pages = 1;
      rootCategories.clear();
      error.value = null;
    }

    if (isLoading.value || isLoadingMore.value) return;

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final res = await repository.getCategories(
        page: page,
        limit: limit,
        q: query.value.isEmpty ? null : query.value,
        sortBy: sortBy.value.isEmpty ? null : sortBy.value,
      );

      final List<CategoryModel> fetched =
          (res['categories'] as List).cast<CategoryModel>();

      page = res['page'] ?? 1;
      pages = res['pages'] ?? 1;

      if (reset) {
        rootCategories.assignAll(fetched);
      } else {
        rootCategories.addAll(fetched);
      }
    } catch (e, st) {
      error.value = e.toString();
      print("CategoryController.fetchCategories ERROR: $e\n$st");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadRootCategories() async {
    try {
      isLoadingRoot.value = true;
      errorInternal.value = null;

      final data = await repository.getRootCategories();
      rootCategories.assignAll(data);
    } catch (e, st) {
      errorInternal.value = e.toString();
      print('CategoryController.loadRootCategories ERROR: $e\n$st');
    } finally {
      isLoadingRoot.value = false;
    }
  }

  Future<void> fetchTopLevelParents({bool force = false}) async {
    if (rootCategories.isNotEmpty && !force) return;

    try {
      isLoadingRoot.value = true;
      errorInternal.value = null;

      await loadRootCategories(); // already populates rootCategories
      // build cache
      _parentNameToId.clear();
      for (final p in rootCategories) {
        final name = (p.name ?? '').trim().toLowerCase();
        if (name.isNotEmpty && p.id != null) {
          _parentNameToId[name] = p.id!;
        }
      }
    } catch (e, st) {
      errorInternal.value = e.toString();
      print('fetchTopLevelParents error: $e\n$st');
    } finally {
      isLoadingRoot.value = false;
    }
  }

  String? resolveParentIdByName(String parentName) {
    final key = parentName.trim().toLowerCase();
    return _parentNameToId[key];
  }

  Future<void> fetchSubcategoriesByParentId(
    String parentId, {
    int page = 1,
    int limit = 100,
    String? q,
    String? sortBy,
    String sortOrder = 'asc',
    bool reset = true,
  }) async {
    if (parentId.isEmpty) return;

    // if not reset and paging and page > subPages -> no-op
    if (!reset && page > subPages) return;

    try {
      isLoadingSub.value = true;
      errorInternal.value = null;

      final effectivePage = reset ? 1 : page;

      final res = await repository.fetchSubcategories(
        parentId: parentId,
        page: effectivePage,
        limit: limit,
        q: q,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      final List<CategoryModel> fetched =
          (res['subcategories'] as List<CategoryModel>);
      final fetchedPage = res['page'] as int? ?? effectivePage;
      final fetchedPages = res['pages'] as int? ?? 1;

      if (reset) {
        subcategories.assignAll(fetched);
        subPage.value = fetchedPage;
      } else {
        subcategories.addAll(fetched);
        subPage.value = fetchedPage;
      }

      subPages = fetchedPages;
      subLimit = limit;
      // store current filter/sort state
      currentParentId.value = parentId;
      subQuery.value = q ?? '';
      subSortBy.value = sortBy ?? '';
      subSortOrder.value = sortOrder;

      errorInternal.value = null;
    } catch (e, st) {
      errorInternal.value = e.toString();
      print('fetchSubcategoriesByParentId error: $e\n$st');
    } finally {
      isLoadingSub.value = false;
    }
  }

  String? getCategoryNameIncludingSub(String? id) {
    if (id == null || id.isEmpty) return null;

    // 1) try current cached lists in this controller
    final allOwn = <CategoryModel>[...rootCategories, ...subcategories];
    final foundOwn = allOwn.firstWhereOrNull((c) => (c.id ?? '') == id);
    if (foundOwn != null) return foundOwn.name;

    // 2) try SubCategoryController caches if registered
    try {
      final subCtrl = Get.find<SubCategoryController>();
      // flatten all lists and search
      final allSubs = subCtrl.subcategoriesByParent.values.expand((e) => e);
      final foundSub = allSubs.firstWhereOrNull((c) => (c.id ?? '') == id);
      if (foundSub != null) return foundSub.name;
    } catch (_) {
      // no SubCategoryController registered — ignore
    }

    // not found
    return null;
  }

  /// Convenience: fetch subcategories using parent **name** (auto-resolve id)
  Future<void> fetchSubcategoriesByParentName(String parentName,
      {int page = 1,
      int limit = 100,
      String? q,
      String? sortBy,
      String sortOrder = 'asc',
      bool reset = true}) async {
    try {
      isLoadingSub.value = true;
      errorInternal.value = null;

      await fetchTopLevelParents(); // ensure parent cache
      final parentId = resolveParentIdByName(parentName);
      if (parentId == null) {
        errorInternal.value = 'Parent category "$parentName" not found';
        subcategories.clear();
        return;
      }

      await fetchSubcategoriesByParentId(parentId,
          page: page,
          limit: limit,
          q: q,
          sortBy: sortBy,
          sortOrder: sortOrder,
          reset: reset);
    } catch (e, st) {
      errorInternal.value = e.toString();
      print('fetchSubcategoriesByParentName error: $e\n$st');
    } finally {
      isLoadingSub.value = false;
    }
  }

  /// Adapter helper used by UI: get subcategories for a parent id (cached)
  List<CategoryModel> getSubcategoriesForParent(String parentId) {
    if (parentId.isEmpty) return <CategoryModel>[];
    if (currentParentId.value == parentId) return subcategories;
    // If a cached value is desired per-parent, you'd store map parentId->list.
    // For now we rely on currentParentId/subcategories.
    return subcategories;
  }

  Future<void> createCategory({
    required String name,
    String? description,
    String? parentId,
    dio.MultipartFile? imageFile,
  }) async {
    try {
      final form = dio.FormData();
      // Required
      form.fields.add(MapEntry("name", name.trim()));

      if (description != null && description.trim().isNotEmpty) {
        form.fields.add(MapEntry("description", description.trim()));
      }

      if (parentId != null && parentId.isNotEmpty) {
        form.fields.add(MapEntry("parent", parentId));
      }

      if (imageFile != null) {
        form.files.add(MapEntry("image", imageFile));
      }

      final created = await repository.createCategory(form);

      // Add into correct list
      if (parentId == null || parentId.isEmpty) {
        // Root category
        rootCategories.insert(0, created);
      } else {
        subcategories.insert(0, created);
        try {
          final subCtrl = Get.find<SubCategoryController>();
          await subCtrl.refetchSubcategories(parentId);
        } catch (_) {}
      }
    } catch (e, st) {
      print('createCategoryWithImage ERROR: $e\n$st');
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateCategory(
    String id, {
    required String name,
    String? description,
    required String parentId,
    dio.MultipartFile? imageFile,
  }) async {
    try {
      final form = dio.FormData();

      form.fields.add(MapEntry("name", name));

      if (description != null && description.trim().isNotEmpty) {
        form.fields.add(MapEntry("description", description.trim()));
      }

      form.fields.add(MapEntry("parent", parentId));

      if (imageFile != null) {
        form.files.add(MapEntry("image", imageFile));
      }

      final updated = await repository.update(id, form);

      // Update lists
      final rootIndex = rootCategories.indexWhere((c) => c.id == id);
      if (rootIndex != -1) rootCategories[rootIndex] = updated;

      final subIndex = subcategories.indexWhere((c) => c.id == id);
      if (subIndex != -1) subcategories[subIndex] = updated;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await repository.delete(id);
      rootCategories.removeWhere((c) => c.id == id);
      subcategories.removeWhere((c) => c.id == id);
      update();
    } catch (e) {
      Get.snackbar('Delete failed', e.toString());
    }
  }

  RxList<CategoryModel> get items => rootCategories;
  RxBool get isLoading => isLoadingRoot;
  RxBool get isLoadingMore => isLoadingMoreInternal;
  RxnString get error => errorInternal;

  @override
  Future<void> refresh() async {
    page = 1;
    await loadRootCategories();
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value) return;
    if (page >= pages) return;

    try {
      isLoadingMoreInternal.value = true;
      page = page + 1;
      final data =
          await repository.getRootCategories(); // or your paginated endpoint
      rootCategories.addAll(data);
    } catch (e) {
      print('CategoryController.loadMore ERROR: $e');
      errorInternal.value = e.toString();
    } finally {
      isLoadingMoreInternal.value = false;
    }
  }
}
