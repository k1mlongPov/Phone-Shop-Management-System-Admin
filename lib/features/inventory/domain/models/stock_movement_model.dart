import 'package:json_annotation/json_annotation.dart';
part 'stock_movement_model.g.dart';

@JsonSerializable()
class StockMovement {
  final String? id;
  final String productId;
  final String productType;
  final String? variantSku;
  final int quantity;
  final String movementType;
  final DateTime? createdAt;
  final String? note;

  StockMovement(
      {this.id,
      required this.productId,
      required this.productType,
      this.variantSku,
      required this.quantity,
      required this.movementType,
      this.createdAt,
      this.note});

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
  Map<String, dynamic> toJson() => _$StockMovementToJson(this);
}
