// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleLine _$SaleLineFromJson(Map<String, dynamic> json) => SaleLine(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      modelType: json['modelType'] as String,
      variantId: json['variantId'] as String?,
      variantLabel: json['variantLabel'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SaleLineToJson(SaleLine instance) => <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'modelType': instance.modelType,
      'variantId': instance.variantId,
      'variantLabel': instance.variantLabel,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
