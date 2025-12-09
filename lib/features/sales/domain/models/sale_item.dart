import 'package:json_annotation/json_annotation.dart';

part 'sale_item.g.dart';

@JsonSerializable()
class SaleItem {
  final String productId;
  final String modelType;
  final int quantity;
  final double unitPrice;
  final String? variantId;

  SaleItem({
    required this.productId,
    required this.modelType,
    required this.quantity,
    required this.unitPrice,
    this.variantId,
  });

  double get lineTotal => unitPrice * quantity;

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}
