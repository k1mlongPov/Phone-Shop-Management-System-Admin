import 'package:json_annotation/json_annotation.dart';

part 'invoice_item.g.dart';

@JsonSerializable()
class InvoiceItem {
  final String productId;
  final String productName;
  final String modelType;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  // Nullable:
  final String? variantId;
  final String? variantSku;
  final String? variantLabel;

  InvoiceItem({
    required this.productId,
    required this.productName,
    required this.modelType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.variantId,
    this.variantSku,
    this.variantLabel,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}
