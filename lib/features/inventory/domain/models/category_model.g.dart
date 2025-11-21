// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      parent: json['parent'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'isActive': instance.isActive,
      'parent': instance.parent,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
