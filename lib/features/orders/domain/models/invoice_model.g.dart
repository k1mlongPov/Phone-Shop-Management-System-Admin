// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      productId: json['productId'] as String?,
      productType: json['productType'] as String,
      variantSku: json['variantSku'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productType': instance.productType,
      'variantSku': instance.variantSku,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'] as String?,
      invoiceNo: json['invoiceNo'] as String,
      customerId: json['customerId'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'invoiceNo': instance.invoiceNo,
      'customerId': instance.customerId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'paid': instance.paid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'status': instance.status,
    };
