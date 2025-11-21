// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    StockMovement(
      id: json['id'] as String?,
      productId: json['productId'] as String,
      productType: json['productType'] as String,
      variantSku: json['variantSku'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      movementType: json['movementType'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$StockMovementToJson(StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productType': instance.productType,
      'variantSku': instance.variantSku,
      'quantity': instance.quantity,
      'movementType': instance.movementType,
      'createdAt': instance.createdAt?.toIso8601String(),
      'note': instance.note,
    };
