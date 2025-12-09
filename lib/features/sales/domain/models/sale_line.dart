import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_line.g.dart';

@JsonSerializable()
class SaleLine {
  String? productId;
  String? productName;
  String modelType;
  String? variantId;
  String? variantLabel;
  int quantity;
  double unitPrice;

  // NEW: Controllers for UI binding
  final TextEditingController qtyController;
  final TextEditingController priceController;

  SaleLine({
    this.productId,
    this.productName,
    required this.modelType,
    this.variantId,
    this.variantLabel,
    this.quantity = 1,
    this.unitPrice = 0,
  })  : qtyController = TextEditingController(text: quantity.toString()),
        priceController = TextEditingController(text: unitPrice.toString());

  double get lineTotal => unitPrice * quantity;

  factory SaleLine.fromJson(Map<String, dynamic> json) =>
      _$SaleLineFromJson(json);

  Map<String, dynamic> toJson() => _$SaleLineToJson(this);
}
