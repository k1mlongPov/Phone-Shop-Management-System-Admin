import 'package:json_annotation/json_annotation.dart';
import 'invoice_item.dart';

part 'invoice_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InvoiceModel {
  @JsonKey(name: "_id")
  final String id;

  final String invoiceNo;

  final String? customer; // customerId
  final String customerName;
  final String? customerPhone;

  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  final List<InvoiceItem> items;

  final Map<String, dynamic>? payment;

  final String? status;
  final String? seller;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvoiceModel({
    required this.id,
    required this.invoiceNo,
    this.customer,
    required this.customerName,
    this.customerPhone,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.items,
    this.payment,
    this.status,
    this.seller,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);
}
