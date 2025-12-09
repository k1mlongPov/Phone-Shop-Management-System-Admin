// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      purchaseHistory: (json['purchaseHistory'] as List<dynamic>?)
              ?.map((e) =>
                  PurchaseHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'notes': instance.notes,
      'purchaseHistory':
          instance.purchaseHistory.map((e) => e.toJson()).toList(),
    };

PurchaseHistoryItem _$PurchaseHistoryItemFromJson(Map<String, dynamic> json) =>
    PurchaseHistoryItem(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      productId: json['productId'] as String?,
      modelType: json['modelType'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      totalSpent: (json['totalSpent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PurchaseHistoryItemToJson(
        PurchaseHistoryItem instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'productId': instance.productId,
      'modelType': instance.modelType,
      'quantity': instance.quantity,
      'totalSpent': instance.totalSpent,
    };
