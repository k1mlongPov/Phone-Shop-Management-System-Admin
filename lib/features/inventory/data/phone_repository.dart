import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';

class PhoneRepository {
  final ApiService api;
  final LocalStorageService storage;

  PhoneRepository({required this.api, required this.storage});

  // ---------------- FETCH LIST ----------------
  Future<Map<String, dynamic>> fetchPhones({
    int page = 1,
    int limit = 12,
    String? q,
    String? sortBy,
    String sortOrder = 'asc',
    String? categoryId,
  }) async {
    // ---------------------------------------------------------
    // QUERY BUILDING
    // ---------------------------------------------------------
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (q != null && q.isNotEmpty) 'q': q,

      // server expects a single key: "sort"
      if (sortBy != null && sortBy.isNotEmpty) 'sort': sortBy,

      // be tolerant — send category under common backend names
      if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      if (categoryId != null && categoryId.isNotEmpty) 'category': categoryId,
      if (categoryId != null && categoryId.isNotEmpty)
        'subcategory': categoryId,
    };
    final res = await api.get(
      '/api/phones',
      query: query,
    );

    final data = res.data as Map<String, dynamic>;
    final rawList = (data['data'] as List<dynamic>?) ?? <dynamic>[];
    final List<Phone> items = [];

    Map<String, dynamic> normalizePhoneRaw(dynamic raw) {
      final Map<String, dynamic> json = (raw is Map<String, dynamic>)
          ? Map<String, dynamic>.from(raw)
          : Map<String, dynamic>.from(raw as Map);

      // Normalize id/_id
      if ((json['id'] == null || json['id'].toString().isEmpty) &&
          json['_id'] != null) {
        if (json['_id'] is String) {
          json['id'] = json['_id'];
        } else if (json['_id'] is Map) {
          final inner = json['_id'] as Map;
          json['id'] =
              (inner['_id'] ?? inner['\$oid'] ?? inner['id'])?.toString();
        } else {
          json['id'] = json['_id'].toString();
        }
      } else if (json['_id'] == null && json['id'] != null) {
        json['_id'] = json['id'];
      }

      // Flatten pricing
      if (json['pricing'] is Map) {
        final Map pr = Map<String, dynamic>.from(json['pricing']);
        if (pr['sellingPrice'] != null) {
          json['sellingPrice'] = pr['sellingPrice'];
        }
        if (pr['purchasePrice'] != null) {
          json['purchasePrice'] = pr['purchasePrice'];
        }
        if (pr['currency'] != null) json['currency'] = pr['currency'];
      }

      // Flatten category into ID string
      if (json['category'] is Map) {
        final cat = Map<String, dynamic>.from(json['category']);
        json['category'] =
            (cat['_id'] ?? cat['id'])?.toString() ?? cat.toString();
      }

      // Flatten supplier
      if (json['supplier'] is Map) {
        final sup = Map<String, dynamic>.from(json['supplier']);
        json['supplier'] =
            (sup['_id'] ?? sup['id'])?.toString() ?? sup.toString();
      }

      // Image cleanup
      if (json['images'] is List) {
        final List imgs = json['images'];
        json['images'] = imgs
            .map((img) {
              if (img == null) return null;
              if (img is String) return img;
              if (img is Map) {
                return (img['url'] ?? img['src'] ?? img['path'] ?? img['image'])
                    ?.toString();
              }
              return img.toString();
            })
            .where((e) => e != null)
            .toList();
      }

      // brand/model corrections
      if (json['brand'] is Map) {
        final b = json['brand'];
        json['brand'] =
            (b['name'] ?? b['_id'] ?? b['id'])?.toString() ?? json['brand'];
      }
      if (json['model'] is Map) {
        final m = json['model'];
        json['model'] =
            (m['name'] ?? m['_id'] ?? m['id'])?.toString() ?? json['model'];
      }

      // numeric stock
      if (json['stock'] is String) {
        json['stock'] = int.tryParse(json['stock']) ?? 0;
      }

      return json;
    }

    // ---------------------------------------------------------
    // PARSE ITEMS
    // ---------------------------------------------------------

    for (var i = 0; i < rawList.length; i++) {
      final raw = rawList[i];
      try {
        final normalized = normalizePhoneRaw(raw);
        items.add(Phone.fromJson(normalized));
      } catch (err, st) {
        try {
          debugPrint(
              '⚠️ Phone.fromJson failed at index $i: $err\nRAW: ${jsonEncode(raw)}\n$st');
        } catch (_) {
          debugPrint('⚠️ Phone.fromJson failed & raw unencodable: $raw');
        }
      }
    }

    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return {
      'phones': items,
      'page': parseInt(data['page']) > 0 ? parseInt(data['page']) : page,
      'pages': parseInt(data['pages']) > 0 ? parseInt(data['pages']) : 1,
      'total': parseInt(data['total']),
    };
  }

  // ---------------- FETCH SINGLE ----------------
  Future<Phone> getPhoneById(String id) async {
    final res = await api.get('/api/phones/$id');
    return Phone.fromJson(res.data);
  }

// ---------------- CREATE PHONE ----------------
  Future<Phone> createPhone({
    required String brand,
    required String model,
    required double purchasePrice,
    required double sellingPrice,
    required String currency,
    required String categoryId,
    String? supplierId,
    Map<String, dynamic>? specs,
    List<Map<String, dynamic>>? variants,
    List<String>? imagePaths,
  }) async {
    final Map<String, dynamic> map = {};

    // BASIC
    map['brand'] = brand;
    map['model'] = model;
    map['currency'] = currency;
    map['category'] = categoryId;

    if (supplierId != null && supplierId.isNotEmpty) {
      map['supplier'] = supplierId;
    }

    // PRICING
    map['pricing[purchasePrice]'] = purchasePrice.toString();
    map['pricing[sellingPrice]'] = sellingPrice.toString();

    // SPECS
    if (specs != null) {
      specs.forEach((key, value) {
        if (value == null) return;

        if (value is Map) {
          value.forEach((subKey, subVal) {
            if (subVal != null) {
              map['specs[$key][$subKey]'] = subVal.toString();
            }
          });
        } else {
          map['specs[$key]'] = value.toString();
        }
      });
    }

    // VARIANTS
    if (variants != null) {
      for (int i = 0; i < variants.length; i++) {
        final v = variants[i];

        map['variants[$i][storage]'] = v['storage'];
        map['variants[$i][color]'] = v['color'];
        map['variants[$i][condition]'] = v['condition'];
        map['variants[$i][stock]'] = v['stock'].toString();
        map['variants[$i][pricing][purchasePrice]'] =
            v['purchasePrice'].toString();
        map['variants[$i][pricing][sellingPrice]'] =
            v['sellingPrice'].toString();
        if (v['sku'] != null) map['variants[$i][sku]'] = v['sku'];
      }
    }

    // IMAGES
    List<MultipartFile> uploads = [];

    if (imagePaths != null) {
      for (final path in imagePaths) {
        uploads.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        );
      }
    }

    if (uploads.isNotEmpty) {
      map['images'] = uploads;
    }

    final formData = FormData.fromMap(map);

    final token = storage.getAuthToken();

    final res = await api.dioClient.post(
      '/api/phones',
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "*/*",
        },
      ),
    );

    return Phone.fromJson(res.data['phone']);
  }

  Future<Phone> updatePhone({
    required String id,
    required String brand,
    required String model,
    required double purchasePrice,
    required double sellingPrice,
    required String currency,
    required String categoryId,
    String? supplierId,
    Map<String, dynamic>? specs,
    List<Map<String, dynamic>>? variants,
    List<String>? imagePaths, // new images (optional)
  }) async {
    final Map<String, dynamic> map = {};

    // BASIC
    map['brand'] = brand;
    map['model'] = model;
    map['currency'] = currency;
    map['category'] = categoryId;

    if (supplierId != null && supplierId.isNotEmpty) {
      map['supplier'] = supplierId;
    }

    // PRICING
    map['pricing[purchasePrice]'] = purchasePrice.toString();
    map['pricing[sellingPrice]'] = sellingPrice.toString();

    // SPECS
    if (specs != null) {
      specs.forEach((key, value) {
        if (value == null) return;

        if (value is Map) {
          value.forEach((subKey, subVal) {
            if (subVal != null) {
              map['specs[$key][$subKey]'] = subVal.toString();
            }
          });
        } else {
          map['specs[$key]'] = value.toString();
        }
      });
    }

    // VARIANTS
    if (variants != null) {
      for (int i = 0; i < variants.length; i++) {
        final v = variants[i];

        map['variants[$i][storage]'] = v['storage'];
        map['variants[$i][color]'] = v['color'];
        map['variants[$i][condition]'] = v['condition'];
        map['variants[$i][stock]'] = v['stock'].toString();

        map['variants[$i][pricing][purchasePrice]'] =
            v['purchasePrice'].toString();
        map['variants[$i][pricing][sellingPrice]'] =
            v['sellingPrice'].toString();

        if (v['sku'] != null) {
          map['variants[$i][sku]'] = v['sku'];
        }
      }
    }

    // IMAGES (replace)
    List<MultipartFile> uploads = [];

    if (imagePaths != null) {
      for (final path in imagePaths) {
        uploads.add(
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        );
      }
    }

    if (uploads.isNotEmpty) {
      map['images'] = uploads;
    }

    final formData = FormData.fromMap(map);

    final token = storage.getAuthToken();

    final res = await api.dioClient.put(
      '/api/phones/$id',
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "*/*",
        },
      ),
    );

    return Phone.fromJson(res.data['phone']);
  }

  // ---------------- DELETE ----------------
  Future<void> deletePhone(String id) async {
    await api.delete('/api/phones/$id');
  }

  // ---------------- RESTOCK ----------------
  Future<Phone> restock({
    required String id,
    required int quantity,
    String? note,
  }) async {
    final res = await api.post(
      '/api/phones/$id/restock',
      {
        'quantity': quantity,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );

    return Phone.fromJson(res.data);
  }
}
