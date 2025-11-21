import 'package:json_annotation/json_annotation.dart';

part 'accessory_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Accessory {
  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String type;
  final String? brand;

  /// pricing object in backend
  final Pricing pricing;

  final String currency;

  final String? sku;
  final List<String>? images;
  final List<String>? compatibility;

  final int stock;
  final int lowStockThreshold;

  /// arbitrary attributes bag stored in `attributes` on backend
  final Map<String, dynamic>? attributes;

  /// backend returns nested object or id string; we map to id string
  @JsonKey(name: 'category')
  final String? categoryId;

  @JsonKey(name: 'supplier')
  final String? supplierId;

  final bool isActive;

  final List<RestockHistory>? restockHistory;
  final List<SaleHistory>? saleHistory;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Accessory({
    this.id,
    required this.name,
    required this.type,
    this.brand,
    required this.pricing,
    this.currency = 'USD',
    this.sku,
    this.images,
    this.compatibility,
    this.stock = 0,
    this.lowStockThreshold = 10,
    this.attributes,
    this.categoryId,
    this.supplierId,
    this.isActive = true,
    this.restockHistory,
    this.saleHistory,
    this.createdAt,
    this.updatedAt,
  });

  /// Virtual: profit margin percentage
  double get profitMargin {
    try {
      final p = pricing;
      if (p.sellingPrice == 0) return 0.0;
      final profit = p.sellingPrice - p.purchasePrice;
      return double.parse(((profit / p.sellingPrice) * 100).toStringAsFixed(2));
    } catch (_) {
      return 0.0;
    }
  }

  Accessory copyWith({
    String? id,
    String? name,
    String? type,
    String? brand,
    Pricing? pricing,
    String? currency,
    String? sku,
    List<String>? images,
    List<String>? compatibility,
    int? stock,
    int? lowStockThreshold,
    Map<String, dynamic>? attributes,
    String? categoryId,
    String? supplierId,
    bool? isActive,
    List<RestockHistory>? restockHistory,
    List<SaleHistory>? saleHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Accessory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      pricing: pricing ?? this.pricing,
      currency: currency ?? this.currency,
      sku: sku ?? this.sku,
      images: images ?? this.images,
      compatibility: compatibility ?? this.compatibility,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      attributes: attributes ?? this.attributes,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      isActive: isActive ?? this.isActive,
      restockHistory: restockHistory ?? this.restockHistory,
      saleHistory: saleHistory ?? this.saleHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Accessory.fromJson(Map<String, dynamic> json) =>
      _$AccessoryFromJson(_normalizeJson(json));

  Map<String, dynamic> toJson() => _$AccessoryToJson(this);

  /// Backend sometimes returns nested objects for category/supplier or pricing in different shapes.
  /// Normalize common shapes so json_serializable mapping works reliably.
  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> raw) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(raw);

    // normalize id / _id
    if ((json['id'] == null || (json['id'] as String).isEmpty) &&
        json['_id'] != null) {
      if (json['_id'] is String) {
        json['id'] = json['_id'];
      } else if (json['_id'] is Map) {
        final inner = Map<String, dynamic>.from(json['_id']);
        json['id'] =
            (inner['_id'] ?? inner['\$oid'] ?? inner['id'])?.toString();
      } else {
        json['id'] = json['_id'].toString();
      }
    } else if (json['_id'] == null && json['id'] != null) {
      json['_id'] = json['id'];
    }

    // normalize pricing: may be under 'pricing' or flattened fields
    if (json['pricing'] is Map) {
      // keep as-is
    } else {
      final purchase = json['purchasePrice'] ?? json['purchase_price'] ?? 0;
      final selling = json['sellingPrice'] ?? json['selling_price'] ?? 0;
      if (purchase != 0 || selling != 0) {
        json['pricing'] = {'purchasePrice': purchase, 'sellingPrice': selling};
      }
    }

    // normalize category / supplier: object or id
    if (json['category'] is Map) {
      final cat = Map<String, dynamic>.from(json['category']);
      json['category'] =
          (cat['_id'] ?? cat['id'])?.toString() ?? cat.toString();
    } else if (json['category'] != null) {
      json['category'] = json['category'].toString();
    }

    if (json['supplier'] is Map) {
      final sup = Map<String, dynamic>.from(json['supplier']);
      json['supplier'] =
          (sup['_id'] ?? sup['id'])?.toString() ?? sup.toString();
    } else if (json['supplier'] != null) {
      json['supplier'] = json['supplier'].toString();
    }

    // ensure images is List<String>
    if (json['images'] is List) {
      json['images'] = (json['images'] as List)
          .map((e) => e?.toString())
          .where((e) => e != null)
          .toList();
    }

    // ensure compatibility is List<String>
    if (json['compatibility'] is List) {
      json['compatibility'] = (json['compatibility'] as List)
          .map((e) => e?.toString())
          .where((e) => e != null)
          .toList();
    }

    // attributes might be nested or missing
    if (json['attributes'] == null && json['attributes'] is! Map) {
      // leave null
    }

    // normalize restockHistory / saleHistory lists (ensure date as ISO or parseable string)
    // (json_serializable will parse them if they are maps with date strings)

    return json;
  }
}

@JsonSerializable()
class Pricing {
  final double purchasePrice;
  final double sellingPrice;

  Pricing({
    required this.purchasePrice,
    required this.sellingPrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
  Map<String, dynamic> toJson() => _$PricingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RestockHistory {
  final DateTime? date;
  final int? quantity;
  final String? note;
  final String? supplier; // supplier id

  RestockHistory({
    this.date,
    this.quantity,
    this.note,
    this.supplier,
  });

  factory RestockHistory.fromJson(Map<String, dynamic> json) =>
      _$RestockHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$RestockHistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaleHistory {
  final DateTime? date;
  final int? quantity;
  final double? soldPrice;
  final String? handledBy;
  final String? customer; // customer id

  SaleHistory({
    this.date,
    this.quantity,
    this.soldPrice,
    this.handledBy,
    this.customer,
  });

  factory SaleHistory.fromJson(Map<String, dynamic> json) =>
      _$SaleHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$SaleHistoryToJson(this);
}
