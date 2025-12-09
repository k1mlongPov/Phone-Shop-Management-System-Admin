// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
      id: json['_id'] as String,
      invoiceNo: json['invoiceNo'] as String,
      customer: json['customer'] as String?,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      payment: json['payment'] as Map<String, dynamic>?,
      status: json['status'] as String?,
      seller: json['seller'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'invoiceNo': instance.invoiceNo,
      'customer': instance.customer,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'total': instance.total,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'payment': instance.payment,
      'status': instance.status,
      'seller': instance.seller,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
