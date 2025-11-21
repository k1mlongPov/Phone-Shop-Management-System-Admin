import 'package:json_annotation/json_annotation.dart';
part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;
  final String? description;
  final String? image;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'parent')
  final dynamic parent;

  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.parent,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  /// Returns parent ID safely no matter what backend format is.
  String? get parentId {
    if (parent == null) return null;
    if (parent is String) return parent;
    if (parent is Map && parent['_id'] != null) return parent['_id'] as String;
    return null;
  }

  /// Returns parent name if included from backend
  String? get parentName {
    if (parent is Map && parent['name'] != null) {
      return parent['name'] as String;
    }
    return null;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
