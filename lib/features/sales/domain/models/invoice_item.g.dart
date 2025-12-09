// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      modelType: json['modelType'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      variantId: json['variantId'] as String?,
      variantSku: json['variantSku'] as String?,
      variantLabel: json['variantLabel'] as String?,
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'modelType': instance.modelType,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'variantId': instance.variantId,
      'variantSku': instance.variantSku,
      'variantLabel': instance.variantLabel,
    };
