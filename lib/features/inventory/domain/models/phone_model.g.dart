// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Phone _$PhoneFromJson(Map<String, dynamic> json) => Phone(
      id: json['id'] as String?,
      brand: json['brand'] as String,
      model: json['model'] as String,
      slug: json['slug'] as String?,
      pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      currency: json['currency'] as String?,
      specs: json['specs'] == null
          ? null
          : Specs.fromJson(json['specs'] as Map<String, dynamic>),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => Variant.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      supplier: json['supplier'] as String?,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 0,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sku: json['sku'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      restockHistory: (json['restockHistory'] as List<dynamic>?)
          ?.map((e) => RestockHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      saleHistory: (json['saleHistory'] as List<dynamic>?)
          ?.map((e) => SaleHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PhoneToJson(Phone instance) => <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'model': instance.model,
      'slug': instance.slug,
      'pricing': instance.pricing.toJson(),
      'currency': instance.currency,
      'specs': instance.specs?.toJson(),
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
      'category': instance.category,
      'supplier': instance.supplier,
      'stock': instance.stock,
      'lowStockThreshold': instance.lowStockThreshold,
      'images': instance.images,
      'sku': instance.sku,
      'isActive': instance.isActive,
      'restockHistory':
          instance.restockHistory?.map((e) => e.toJson()).toList(),
      'saleHistory': instance.saleHistory?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
    };

Variant _$VariantFromJson(Map<String, dynamic> json) => Variant(
      id: json['_id'] as String?,
      storage: json['storage'] as String?,
      color: json['color'] as String?,
      condition: PhoneConditionX.fromBackend(json['condition'] as String?),
      pricing: json['pricing'] == null
          ? null
          : Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      sku: json['sku'] as String?,
    );

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      '_id': instance.id,
      'storage': instance.storage,
      'color': instance.color,
      'condition': Variant._conditionToJson(instance.condition),
      'pricing': instance.pricing?.toJson(),
      'stock': instance.stock,
      'sku': instance.sku,
    };

Specs _$SpecsFromJson(Map<String, dynamic> json) => Specs(
      chipset: json['chipset'] as String?,
      ram: (json['ram'] as num?)?.toInt(),
      storage: (json['storage'] as num?)?.toInt(),
      display: json['display'] == null
          ? null
          : Display.fromJson(json['display'] as Map<String, dynamic>),
      cameras: json['cameras'] == null
          ? null
          : Cameras.fromJson(json['cameras'] as Map<String, dynamic>),
      batteryHealth: (json['batteryHealth'] as num?)?.toDouble(),
      chargingW: (json['chargingW'] as num?)?.toInt(),
      os: json['os'] as String?,
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SpecsToJson(Specs instance) => <String, dynamic>{
      'chipset': instance.chipset,
      'ram': instance.ram,
      'storage': instance.storage,
      'display': instance.display?.toJson(),
      'cameras': instance.cameras?.toJson(),
      'batteryHealth': instance.batteryHealth,
      'chargingW': instance.chargingW,
      'os': instance.os,
      'colors': instance.colors,
    };

Display _$DisplayFromJson(Map<String, dynamic> json) => Display(
      sizeIn: (json['sizeIn'] as num?)?.toDouble(),
      resolution: json['resolution'] as String?,
      type: json['type'] as String?,
      refreshRate: (json['refreshRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DisplayToJson(Display instance) => <String, dynamic>{
      'sizeIn': instance.sizeIn,
      'resolution': instance.resolution,
      'type': instance.type,
      'refreshRate': instance.refreshRate,
    };

Cameras _$CamerasFromJson(Map<String, dynamic> json) => Cameras(
      main: json['main'] as String?,
      front: json['front'] as String?,
    );

Map<String, dynamic> _$CamerasToJson(Cameras instance) => <String, dynamic>{
      'main': instance.main,
      'front': instance.front,
    };

RestockHistory _$RestockHistoryFromJson(Map<String, dynamic> json) =>
    RestockHistory(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      quantity: (json['quantity'] as num?)?.toInt(),
      note: json['note'] as String?,
      supplier: json['supplier'] as String?,
    );

Map<String, dynamic> _$RestockHistoryToJson(RestockHistory instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'quantity': instance.quantity,
      'note': instance.note,
      'supplier': instance.supplier,
    };

SaleHistory _$SaleHistoryFromJson(Map<String, dynamic> json) => SaleHistory(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      quantity: (json['quantity'] as num?)?.toInt(),
      soldPrice: (json['soldPrice'] as num?)?.toDouble(),
      handledBy: json['handledBy'] as String?,
      customer: json['customer'] as String?,
    );

Map<String, dynamic> _$SaleHistoryToJson(SaleHistory instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'quantity': instance.quantity,
      'soldPrice': instance.soldPrice,
      'handledBy': instance.handledBy,
      'customer': instance.customer,
    };
