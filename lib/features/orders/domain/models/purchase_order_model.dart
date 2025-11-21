import 'package:json_annotation/json_annotation.dart';
part 'purchase_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class POItem {
  final String? productId;
  final String modelType;
  final String? variantSku;
  final int quantity;
  final double unitCost;
  final DateTime? expectedDate;

  POItem(
      {this.productId,
      required this.modelType,
      this.variantSku,
      required this.quantity,
      required this.unitCost,
      this.expectedDate});

  factory POItem.fromJson(Map<String, dynamic> json) => _$POItemFromJson(json);
  Map<String, dynamic> toJson() => _$POItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PurchaseOrder {
  final String? id;
  final String poNo;
  final String supplierId;
  final List<POItem> items;
  final double total;
  final String? status;
  final DateTime? createdAt;

  PurchaseOrder(
      {this.id,
      required this.poNo,
      required this.supplierId,
      this.items = const [],
      required this.total,
      this.status,
      this.createdAt});

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseOrderToJson(this);
}
