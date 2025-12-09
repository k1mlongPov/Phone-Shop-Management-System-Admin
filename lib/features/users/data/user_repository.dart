import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';

class UsersRepository {
  final ApiService api;

  UsersRepository({required this.api});

  Future<UserModel?> setUserRoles(String userId, List<String> roles) async {
    try {
      final response = await api.dioClient.patch(
        "/api/users/$userId/roles",
        data: {"roles": roles},
      );

      return UserModel.fromJson(response.data["user"]);
    } catch (e) {
      debugPrint("❌ setUserRoles error: $e");
      rethrow;
    }
  }

  Future<UserModel?> addRole(String userId, String role) async {
    try {
      final response = await api.dioClient.patch(
        "/api/users/$userId/roles/add",
        data: {"role": role},
      );

      return UserModel.fromJson(response.data["user"]);
    } catch (e) {
      debugPrint("❌ addRole error: $e");
      rethrow;
    }
  }

  Future<UserModel?> removeRole(String userId, String role) async {
    try {
      final response = await api.dioClient.patch(
        "/api/users/$userId/roles/remove",
        data: {"role": role},
      );

      return UserModel.fromJson(response.data["user"]);
    } catch (e) {
      debugPrint("❌ removeRole error: $e");
      rethrow;
    }
  }
}
