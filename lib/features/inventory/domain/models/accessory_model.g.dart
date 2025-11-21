// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accessory _$AccessoryFromJson(Map<String, dynamic> json) => Accessory(
      id: json['_id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String?,
      pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      currency: json['currency'] as String? ?? 'USD',
      sku: json['sku'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      compatibility: (json['compatibility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 10,
      attributes: json['attributes'] as Map<String, dynamic>?,
      categoryId: json['category'] as String?,
      supplierId: json['supplier'] as String?,
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

Map<String, dynamic> _$AccessoryToJson(Accessory instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'brand': instance.brand,
      'pricing': instance.pricing.toJson(),
      'currency': instance.currency,
      'sku': instance.sku,
      'images': instance.images,
      'compatibility': instance.compatibility,
      'stock': instance.stock,
      'lowStockThreshold': instance.lowStockThreshold,
      'attributes': instance.attributes,
      'category': instance.categoryId,
      'supplier': instance.supplierId,
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
