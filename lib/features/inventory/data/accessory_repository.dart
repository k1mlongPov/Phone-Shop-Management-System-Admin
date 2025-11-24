// features/inventory/data/accessory_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/accessory_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';

class AccessoryRepository {
  final ApiService api;
  AccessoryRepository({required this.api});

  Future<Map<String, dynamic>> fetchAccessories({
    int page = 1,
    int limit = 12,
    String? q,
    String? sortBy, // server 'sort' key
    AccessorySortField? sortField,
    String? categoryId,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (q != null && q.isNotEmpty) 'q': q,
      if (sortBy != null && sortBy.isNotEmpty) 'sort': sortBy,
      if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      if (categoryId != null && categoryId.isNotEmpty) 'category': categoryId,
      if (categoryId != null && categoryId.isNotEmpty)
        'subcategory': categoryId,
    };

    final res = await api.get('/api/accessories', query: query);

    final body = res.data;
    List<dynamic> rawList = <dynamic>[];
    int pageNum = page;
    int pages = 1;
    int total = 0;

    try {
      if (body is Map && body['data'] != null) {
        rawList = (body['data'] as List<dynamic>?) ?? <dynamic>[];
        pageNum = _parseInt(body['page']);
        pages = _parseInt(body['pages']);
        total = _parseInt(body['total']);
      } else if (body is List) {
        rawList = body;
        pageNum = page;
        pages = 1;
        total = rawList.length;
      } else {
        rawList = <dynamic>[body];
        pageNum = page;
        pages = 1;
        total = 1;
      }
    } catch (e, st) {
      print(
          'AccessoryRepository: response parsing error: $e\n$st\nraw=${res.data}');
      rawList = <dynamic>[];
    }

    final List<Accessory> items = [];
    for (var i = 0; i < rawList.length; i++) {
      final raw = rawList[i];
      try {
        final map = raw is Map<String, dynamic>
            ? Map<String, dynamic>.from(raw)
            : Map<String, dynamic>.from(raw as Map);
        // Use Accessory.fromJson which contains normalization logic
        items.add(Accessory.fromJson(map));
      } catch (e, st) {
        // attempt to decode JSON string
        try {
          if (raw is String) {
            final decoded = jsonDecode(raw);
            final map = decoded is Map<String, dynamic>
                ? Map<String, dynamic>.from(decoded)
                : Map<String, dynamic>.from(decoded as Map);
            items.add(Accessory.fromJson(map));
            continue;
          }
        } catch (_) {}
        print(
            'AccessoryRepository: failed to parse accessory at index $i: $e\nraw=$raw\n$st');
      }
    }

    return {
      'accessories': items,
      'page': (pageNum > 0) ? pageNum : page,
      'pages': (pages > 0) ? pages : 1,
      'total': total,
    };
  }

  // ----------------- GET SINGLE -----------------
  Future<Accessory> getAccessory(String id) async {
    final res = await api.get('/api/accessories/$id');
    final Map<String, dynamic> map = res.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(res.data)
        : {'data': res.data};
    // If backend wraps with data: { ... }
    final payload = map['data'] is Map
        ? Map<String, dynamic>.from(map['data'])
        : Map<String, dynamic>.from(res.data);
    return Accessory.fromJson(payload);
  }

  Future<Accessory> createAccessory({
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
    int lowStockThreshold = 10,
  }) async {
    final form = FormData();

    // Basic fields
    form.fields.addAll([
      MapEntry("name", name),
      MapEntry("type", type),
      if (brand != null) MapEntry("brand", brand),
      MapEntry("pricing[purchasePrice]", purchasePrice.toString()),
      MapEntry("pricing[sellingPrice]", sellingPrice.toString()),
      MapEntry("currency", currency),
      MapEntry("stock", stock.toString()),
      MapEntry("lowStockThreshold", lowStockThreshold.toString()),
      MapEntry("category", categoryId),
      MapEntry("supplier", supplierId),
    ]);

    // Attributes
    if (attributes != null) {
      attributes.forEach((key, value) {
        if (value != null) {
          form.fields.add(MapEntry("attributes[$key]", value.toString()));
        }
      });
    }

    // Compatibility
    if (compatibility != null) {
      for (int i = 0; i < compatibility.length; i++) {
        form.fields.add(MapEntry("compatibility[$i]", compatibility[i]));
      }
    }

    // Images
    if (imagePaths != null) {
      for (final path in imagePaths) {
        form.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              path,
              filename: path.split('/').last,
            ),
          ),
        );
      }
    }

    final response = await api.post("/api/accessories", form);

    return Accessory.fromJson(response.data["data"]);
  }

  Future<Accessory> updateAccessory({
    required String id,
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
    List<String>? imagePaths, // ONLY new images
    int? stock,
    int? lowStockThreshold,
  }) async {
    final form = FormData();

    // BASIC FIELDS
    form.fields.addAll([
      MapEntry("name", name),
      MapEntry("type", type),
      if (brand != null) MapEntry("brand", brand),
      MapEntry("pricing[purchasePrice]", purchasePrice.toString()),
      MapEntry("pricing[sellingPrice]", sellingPrice.toString()),
      MapEntry("currency", currency),
      MapEntry("category", categoryId),
      MapEntry("supplier", supplierId),
    ]);

    if (stock != null) {
      form.fields.add(MapEntry("stock", stock.toString()));
    }
    if (lowStockThreshold != null) {
      form.fields
          .add(MapEntry("lowStockThreshold", lowStockThreshold.toString()));
    }

    // ATTRIBUTES
    if (attributes != null) {
      attributes.forEach((key, value) {
        if (value != null) {
          form.fields.add(MapEntry("attributes[$key]", value.toString()));
        }
      });
    }

    // COMPATIBILITY
    if (compatibility != null) {
      for (int i = 0; i < compatibility.length; i++) {
        form.fields.add(MapEntry("compatibility[$i]", compatibility[i]));
      }
    }

    // IMAGES (Only new uploads)
    if (imagePaths != null) {
      for (final path in imagePaths) {
        form.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              path,
              filename: path.split('/').last,
            ),
          ),
        );
      }
    }

    final response = await api.put("/api/accessories/$id", form);

    return Accessory.fromJson(response.data["data"]);
  }

  // ----------------- DELETE -----------------
  Future<void> deleteAccessory(String id) async {
    await api.delete('/api/accessories/$id');
  }

  // ----------------- RESTOCK -----------------
  Future<Accessory> restock({
    required String id,
    required int quantity,
    String? note,
  }) async {
    final res = await api.post('/api/accessories/$id/restock', {
      'quantity': quantity,
      if (note != null && note.isNotEmpty) 'note': note,
    });

    final data = res.data is Map && res.data['data'] != null
        ? res.data['data'] as Map<String, dynamic>
        : res.data as Map<String, dynamic>;
    return Accessory.fromJson(Map<String, dynamic>.from(data));
  }

  // ----------------- HELPERS -----------------
  int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }
}
