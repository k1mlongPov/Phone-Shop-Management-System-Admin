import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final bool verification;
  final String? profile;
  final List<String> roles;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final List<PurchaseHistoryItem> purchaseHistory;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.verification,
    this.profile,
    required this.roles,
    required this.isActive,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.address,
    required this.purchaseHistory,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d == null) return null;

      if (d is String) {
        return DateTime.tryParse(d);
      }

      if (d is Map && d.containsKey("\$date")) {
        return DateTime.tryParse(d["\$date"]);
      }

      return null;
    }

    return UserModel(
      id: json['_id'] ?? "",
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      verification: json['verification'] ?? false,
      profile: json['profile'],
      roles: List<String>.from(json['roles'] ?? []),
      isActive: json['isActive'] ?? true,
      lastLogin: parseDate(json['lastLogin']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      address:
          json['address'] is Map ? json['address']['_id'] : json['address'],
      purchaseHistory: (json['purchaseHistory'] as List<dynamic>? ?? [])
          .map((e) => PurchaseHistoryItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "username": username,
      "email": email,
      "phone": phone,
      "verification": verification,
      "profile": profile,
      "roles": roles,
      "isActive": isActive,
      "lastLogin": lastLogin?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "address": address,
      "purchaseHistory": purchaseHistory.map((e) => e.toJson()).toList(),
    };
  }
}
