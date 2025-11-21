// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

POItem _$POItemFromJson(Map<String, dynamic> json) => POItem(
      productId: json['productId'] as String?,
      modelType: json['modelType'] as String,
      variantSku: json['variantSku'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
      expectedDate: json['expectedDate'] == null
          ? null
          : DateTime.parse(json['expectedDate'] as String),
    );

Map<String, dynamic> _$POItemToJson(POItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'modelType': instance.modelType,
      'variantSku': instance.variantSku,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
      'expectedDate': instance.expectedDate?.toIso8601String(),
    };

PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) =>
    PurchaseOrder(
      id: json['id'] as String?,
      poNo: json['poNo'] as String,
      supplierId: json['supplierId'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => POItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PurchaseOrderToJson(PurchaseOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poNo': instance.poNo,
      'supplierId': instance.supplierId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
