// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => SaleItem(
      productId: json['productId'] as String,
      modelType: json['modelType'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      variantId: json['variantId'] as String?,
    );

Map<String, dynamic> _$SaleItemToJson(SaleItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'modelType': instance.modelType,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'variantId': instance.variantId,
    };
