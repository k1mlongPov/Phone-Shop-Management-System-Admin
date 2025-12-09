import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/users/data/user_repository.dart';

class UsersController extends GetxController {
  final UsersRepository repo;

  UsersController({required this.repo});

  RxList<UserModel> users = <UserModel>[].obs;
  RxBool isLoading = false.obs;

  UserModel? findUserById(String id) {
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUserRoles(String userId, List<String> roles) async {
    isLoading(true);
    try {
      final updated = await repo.setUserRoles(userId, roles);

      if (updated != null) {
        final index = users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          users[index] = updated;
          users.refresh();
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> updateSingleUserRole(String userId, String role) async {
    isLoading(true);
    try {
      final updated =
          await repo.setUserRoles(userId, [role]); // send array with one role

      if (updated != null) {
        final index = users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          users[index] = updated;
          users.refresh();
        }
      }
    } finally {
      isLoading(false);
    }
  }

  // -------------------------------------------------------
  // Add one role
  // -------------------------------------------------------
  Future<void> addUserRole(String userId, String role) async {
    isLoading(true);
    try {
      final updated = await repo.addRole(userId, role);

      if (updated != null) {
        final index = users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          users[index] = updated;
          users.refresh();
        }
      }
    } finally {
      isLoading(false);
    }
  }

  // -------------------------------------------------------
  // Remove one role
  // -------------------------------------------------------
  Future<void> removeUserRole(String userId, String role) async {
    isLoading(true);
    try {
      final updated = await repo.removeRole(userId, role);

      if (updated != null) {
        final index = users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          users[index] = updated;
          users.refresh();
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
