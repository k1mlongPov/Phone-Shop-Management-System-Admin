import 'package:json_annotation/json_annotation.dart';
part 'supplier_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SupplierModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool active;

  final List<SuppliedProduct>? suppliedProducts;

  final String? createdAt;
  final String? updatedAt;

  SupplierModel({
    this.id,
    this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.active = true,
    this.suppliedProducts,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}

@JsonSerializable()
class SuppliedProduct {
  final String? productId;
  final String? modelType;
  final String? lastRestockDate;

  SuppliedProduct({
    this.productId,
    this.modelType,
    this.lastRestockDate,
  });

  factory SuppliedProduct.fromJson(Map<String, dynamic> json) =>
      _$SuppliedProductFromJson(json);

  Map<String, dynamic> toJson() => _$SuppliedProductToJson(this);
}
