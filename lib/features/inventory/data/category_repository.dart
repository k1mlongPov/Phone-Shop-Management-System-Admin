import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';

class CategoryRepository {
  final ApiService api;
  CategoryRepository({required this.api});

  // ----------------- GET ROOT CATEGORIES -----------------
  Future<List<CategoryModel>> getRootCategories() async {
    final res = await api.get('/api/categories');
    final body = res.data;

    final list = (body['data'] as List?) ?? [];
    return list.map((e) => _mapToCategory(e)).toList();
  }

  Future<Map<String, dynamic>> getCategories({
    int page = 1,
    int limit = 20,
    String? q,
    String? sortBy,
  }) async {
    final res = await api.get('/api/categories', query: {
      'page': page,
      'limit': limit,
      if (q != null && q.isNotEmpty) 'q': q,
      if (sortBy != null && sortBy.isNotEmpty) 'sort': sortBy,
    });

    final body = res.data as Map<String, dynamic>;

    return {
      'categories': (body['data'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      'page': body['page'],
      'pages': body['pages'],
      'total': body['total'],
    };
  }

  // ----------------- LIST ALL SUBCATEGORIES (simple) -----------------
  Future<List<CategoryModel>> getAllSubcategories() async {
    final res = await api.get('/api/categories/sub');
    final body = res.data;

    final list = (body['data'] as List?) ?? [];
    return list.map((e) => _mapToCategory(e)).toList();
  }

  Future<Map<String, dynamic>> fetchSubcategories({
    String? parentId,
    int page = 1,
    int limit = 100,
    String? q,
    String? sortBy,
    String sortOrder = 'asc',
  }) async {
    final res = await api.get('/api/categories/sub', query: {
      'page': page,
      'limit': limit,
      if (parentId != null && parentId.isNotEmpty) 'parentId': parentId,
      if (q != null && q.isNotEmpty) 'q': q,
      if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      if (sortBy != null && sortBy.isNotEmpty) 'sort_order': sortOrder,
    });

    final body = res.data as Map<String, dynamic>? ?? {};
    final raw = (body['data'] as List<dynamic>?) ?? <dynamic>[];

    final out = <CategoryModel>[];
    for (var i = 0; i < raw.length; i++) {
      final item = raw[i];
      try {
        out.add(item is Map<String, dynamic>
            ? CategoryModel.fromJson(item)
            : CategoryModel.fromJson(Map<String, dynamic>.from(item as Map)));
      } catch (e, st) {
        debugPrint('Subcategory parse error index $i: $e\n$item\n$st');
      }
    }

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    final pageNum = parseInt(body['page']);
    final pages = parseInt(body['pages']);
    final total = parseInt(body['total']);

    return {
      'subcategories': out,
      'page': pageNum > 0 ? pageNum : page,
      'pages': pages > 0 ? pages : 1,
      'total': total,
    };
  }

  // ----------------- CREATE -----------------
  Future<CategoryModel> createCategory(FormData form) async {
    final res = await api.post('/api/categories', form);
    final data = res.data['data'];

    return CategoryModel.fromJson(
      data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
    );
  }

  // ----------------- UPDATE -----------------
  Future<CategoryModel> update(String id, FormData form) async {
    final res = await api.put('/api/categories/$id', form);
    final data = res.data['data'];

    return CategoryModel.fromJson(
      data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
    );
  }

  // ----------------- DELETE -----------------
  Future<void> delete(String id) async {
    await api.delete('/api/categories/$id');
  }

  // ----------------- Mapping Helper -----------------
  CategoryModel _mapToCategory(dynamic raw) {
    final json =
        raw is Map<String, dynamic> ? raw : Map<String, dynamic>.from(raw);

    return CategoryModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      parent: json['parent'] is Map
          ? json['parent']['_id']?.toString()
          : json['parent']?.toString(),
      isActive: json['isActive'] ?? true,
    );
  }
}
