// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    SupplierModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      contactName: json['contactName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      active: json['active'] as bool? ?? true,
      suppliedProducts: (json['suppliedProducts'] as List<dynamic>?)
          ?.map((e) => SuppliedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'contactName': instance.contactName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'notes': instance.notes,
      'active': instance.active,
      'suppliedProducts':
          instance.suppliedProducts?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

SuppliedProduct _$SuppliedProductFromJson(Map<String, dynamic> json) =>
    SuppliedProduct(
      productId: json['productId'] as String?,
      modelType: json['modelType'] as String?,
      lastRestockDate: json['lastRestockDate'] as String?,
    );

Map<String, dynamic> _$SuppliedProductToJson(SuppliedProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'modelType': instance.modelType,
      'lastRestockDate': instance.lastRestockDate,
    };
