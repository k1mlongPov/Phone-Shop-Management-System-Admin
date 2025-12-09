import 'package:flutter/material.dart';

class SaleLineItem {
  String? productId;
  String? productName;
  String? modelType;
  String? variantId;
  String? variantLabel;

  int quantity;
  double unitPrice;

  // UI-only: not sent to backend
  int availableStock;

  // Controllers for LineTile UI
  final TextEditingController qtyController;
  final TextEditingController priceController;

  SaleLineItem({
    this.productId,
    this.productName,
    this.modelType,
    this.variantId,
    this.variantLabel,
    this.quantity = 1,
    this.unitPrice = 0,
    this.availableStock = 0,
  })  : qtyController = TextEditingController(text: quantity.toString()),
        priceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2));

  double get lineTotal => quantity * unitPrice;
}
