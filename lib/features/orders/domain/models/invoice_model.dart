import 'package:json_annotation/json_annotation.dart';
part 'invoice_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InvoiceItem {
  final String? productId;
  final String productType;
  final String? variantSku;
  final int quantity;
  final double unitPrice;

  InvoiceItem(
      {this.productId,
      required this.productType,
      this.variantSku,
      required this.quantity,
      required this.unitPrice});

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Invoice {
  final String? id;
  final String invoiceNo;
  final String customerId;
  final List<InvoiceItem> items;
  final double total;
  final double paid;
  final DateTime? createdAt;
  final String? status;

  Invoice(
      {this.id,
      required this.invoiceNo,
      required this.customerId,
      this.items = const [],
      required this.total,
      required this.paid,
      this.createdAt,
      this.status});

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
