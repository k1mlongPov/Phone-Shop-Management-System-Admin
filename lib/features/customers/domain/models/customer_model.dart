import 'package:json_annotation/json_annotation.dart';
part 'customer_model.g.dart';

@JsonSerializable()
class Customer {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;

  Customer(
      {this.id, this.name, this.phone, this.email, this.address, this.notes});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
