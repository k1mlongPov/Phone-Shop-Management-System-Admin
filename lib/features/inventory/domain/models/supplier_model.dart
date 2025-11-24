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

  factory SupplierModel.fromJson(Map<String, dynamic> raw) {
    final json = Map<String, dynamic>.from(raw);

    // Normalize id
    if (json['_id'] != null && json['id'] == null) {
      json['id'] = json['_id'].toString();
    }

    // Normalize suppliedProducts list
    if (json['suppliedProducts'] is List) {
      final list = json['suppliedProducts'] as List;

      json['suppliedProducts'] = list.map((p) {
        final map = Map<String, dynamic>.from(p);

        // Normalize productId object -> string
        if (map['productId'] is Map) {
          final idMap = Map<String, dynamic>.from(map['productId']);
          map['productId'] =
              idMap['_id']?.toString() ?? idMap['id']?.toString() ?? "";
        } else {
          map['productId'] = map['productId']?.toString() ?? "";
        }

        // Normalize lastRestockDate to string
        if (map['lastRestockDate'] != null) {
          map['lastRestockDate'] = map['lastRestockDate'].toString();
        }

        return map;
      }).toList();
    }

    return _$SupplierModelFromJson(json);
  }

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
