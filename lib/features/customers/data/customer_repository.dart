import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';

class CustomersRepository {
  final ApiService api;

  CustomersRepository({required this.api});

  /// Fetch customers collection
  Future<List<Customer>> fetchCustomers() async {
    final res = await api.get("/api/customers");

    final List list = res.data["data"] ?? [];
    return list.map((e) => Customer.fromJson(e)).toList();
  }

  /// Fetch users filtered by role: Customer / Staff / Admin
  Future<List<UserModel>> fetchUsersByRole(String role) async {
    final res = await api.get("/api/customers/users", query: {
      "role": role,
    });

    final List list = res.data["data"] ?? [];
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<Customer?> createCustomer(Customer model) async {
    final res = await api.post("/api/customers", model.toJson());

    if (res.data["success"] != true) return null;

    return Customer.fromJson(res.data["data"]);
  }

  Future<Customer?> updateCustomer(
      String id, Map<String, dynamic> payload) async {
    final res = await api.put("/api/customers/$id", payload);

    if (res.data["success"] != true) return null;

    return Customer.fromJson(res.data["data"]);
  }
}
