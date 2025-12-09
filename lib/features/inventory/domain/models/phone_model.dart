import 'package:json_annotation/json_annotation.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/phone_condition.dart';
part 'phone_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Phone {
  final String? id;
  final String brand;
  final String model;
  final String? slug;

  final Pricing pricing;
  final String? currency;

  final Specs? specs;
  final List<Variant>? variants;

  final String? category;
  final String? supplier;

  final int stock;
  final int lowStockThreshold;

  final List<String>? images;
  final String? sku;
  final bool isActive;

  final List<RestockHistory>? restockHistory;
  final List<SaleHistory>? saleHistory;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Phone({
    this.id,
    required this.brand,
    required this.model,
    this.slug,
    required this.pricing,
    this.currency,
    this.specs,
    this.variants,
    this.category,
    this.supplier,
    this.stock = 0,
    this.lowStockThreshold = 0,
    this.images,
    this.sku,
    this.isActive = true,
    this.restockHistory,
    this.saleHistory,
    this.createdAt,
    this.updatedAt,
  });

  /// Profit margin (frontend calculation)
  double get profitMargin {
    if (pricing.sellingPrice == 0) return 0.0;
    final profit = pricing.sellingPrice - pricing.purchasePrice;
    return double.parse(
        ((profit / pricing.sellingPrice) * 100).toStringAsFixed(2));
  }

  /// Total stock from variants
  int get totalStock {
    if (variants == null || variants!.isEmpty) return stock;
    return variants!.fold<int>(0, (sum, v) => sum + (v.stock ?? 0));
  }

  Phone copyWith({
    String? id,
    String? brand,
    String? model,
    String? slug,
    Pricing? pricing,
    String? currency,
    Specs? specs,
    List<Variant>? variants,
    String? category,
    String? supplier,
    int? stock,
    int? lowStockThreshold,
    List<String>? images,
    String? sku,
    bool? isActive,
    List<RestockHistory>? restockHistory,
    List<SaleHistory>? saleHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Phone(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      slug: slug ?? this.slug,
      pricing: pricing ?? this.pricing,
      currency: currency ?? this.currency,
      specs: specs ?? this.specs,
      variants: variants ?? this.variants,
      category: category ?? this.category,
      supplier: supplier ?? this.supplier,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      images: images ?? this.images,
      sku: sku ?? this.sku,
      isActive: isActive ?? this.isActive,
      restockHistory: restockHistory ?? this.restockHistory,
      saleHistory: saleHistory ?? this.saleHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneToJson(this);
}

/// ------------------------------------------------------
/// PRICING
/// ------------------------------------------------------
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

/// ------------------------------------------------------
/// VARIANT
/// ------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class Variant {
  @JsonKey(name: '_id')
  final String? id;
  final String? storage;
  final String? color;

  @JsonKey(fromJson: PhoneConditionX.fromBackend, toJson: _conditionToJson)
  final PhoneCondition condition;

  final Pricing? pricing;
  final int? stock;
  final String? sku;

  Variant({
    this.id,
    this.storage,
    this.color,
    required this.condition,
    this.pricing,
    this.stock = 0,
    this.sku,
  });

  static String _conditionToJson(PhoneCondition c) => c.backendValue;

  Variant copyWith({
    String? id,
    String? storage,
    String? color,
    PhoneCondition? condition,
    Pricing? pricing,
    int? stock,
    String? sku,
  }) {
    return Variant(
      id: id ?? this.id,
      storage: storage ?? this.storage,
      color: color ?? this.color,
      condition: condition ?? this.condition,
      pricing: pricing ?? this.pricing,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
    );
  }

  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);
}

/// ------------------------------------------------------
/// SPECS
/// ------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class Specs {
  final String? chipset;
  final int? ram;
  final int? storage;

  final Display? display;
  final Cameras? cameras;

  final double? batteryHealth;
  final int? chargingW;
  final String? os;
  final List<String>? colors;

  Specs({
    this.chipset,
    this.ram,
    this.storage,
    this.display,
    this.cameras,
    this.batteryHealth,
    this.chargingW,
    this.os,
    this.colors,
  });

  factory Specs.fromJson(Map<String, dynamic> json) => _$SpecsFromJson(json);

  Map<String, dynamic> toJson() => _$SpecsToJson(this);
}

/// ------------------------------------------------------
/// DISPLAY
/// ------------------------------------------------------
@JsonSerializable()
class Display {
  final double? sizeIn;
  final String? resolution;
  final String? type;
  final int? refreshRate;

  Display({
    this.sizeIn,
    this.resolution,
    this.type,
    this.refreshRate,
  });

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayToJson(this);
}

/// ------------------------------------------------------
/// CAMERAS
/// ------------------------------------------------------
@JsonSerializable()
class Cameras {
  final String? main;
  final String? front;

  Cameras({this.main, this.front});

  factory Cameras.fromJson(Map<String, dynamic> json) =>
      _$CamerasFromJson(json);

  Map<String, dynamic> toJson() => _$CamerasToJson(this);
}

/// ------------------------------------------------------
/// RESTOCK HISTORY
/// ------------------------------------------------------
@JsonSerializable()
class RestockHistory {
  final DateTime? date;
  final int? quantity;
  final String? note;
  final String? supplier;

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

@JsonSerializable()
class SaleHistory {
  final DateTime? date;
  final int? quantity;
  final double? soldPrice;
  final String? handledBy;
  final String? customer;

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
