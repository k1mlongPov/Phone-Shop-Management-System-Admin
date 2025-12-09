import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/dashboard/domain/models/restock_entry.dart';

class DashboardRepository {
  final ApiService api;
  DashboardRepository({required this.api});

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    final res = await api.get("/api/dashboard/stats");
    return res.data;
  }

  Future<List<RestockEntry>> fetchRestockHistory() async {
    final res = await api.get("/api/dashboard/restock-history");

    final data = res.data;

    if (data == null || data["success"] != true) {
      return [];
    }

    final list = data["data"];
    if (list is! List) return [];

    return list
        .map((e) => RestockEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Map<String, List<double>>> fetchSevenDayRevenue() async {
    final res = await api.get("/api/dashboard/revenue-7-days");

    if (res.data == null || res.data["success"] != true) {
      return {
        "phone": List<double>.filled(7, 0),
        "accessory": List<double>.filled(7, 0),
      };
    }
    return {
      "phone": List<double>.from(res.data["phone"].map((e) => e * 1.0)),
      "accessory": List<double>.from(res.data["accessory"].map((e) => e * 1.0)),
    };
  }
}
