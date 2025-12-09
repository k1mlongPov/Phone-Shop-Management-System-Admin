import 'package:json_annotation/json_annotation.dart';
part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer {
  @JsonKey(name: "_id")
  final String? id;

  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;

  @JsonKey(defaultValue: <PurchaseHistoryItem>[])
  final List<PurchaseHistoryItem> purchaseHistory;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.purchaseHistory = const [],
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class PurchaseHistoryItem {
  final DateTime? date;
  final String? productId;
  final String? modelType;
  final int? quantity;
  final double? totalSpent;

  PurchaseHistoryItem({
    this.date,
    this.productId,
    this.modelType,
    this.quantity,
    this.totalSpent,
  });

  factory PurchaseHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseHistoryItemToJson(this);
}
