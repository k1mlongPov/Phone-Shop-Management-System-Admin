import 'package:phone_management_system_admin/core/services/api_service.dart';

class RestockRepository {
  final ApiService api;

  RestockRepository({required this.api});

  Future<dynamic> restockMany({
    required List<Map<String, dynamic>> items,
    required String supplierId,
    String? note,
  }) async {
    final payload = {
      "items": items,
      "supplierId": supplierId,
      "note": note ?? "",
    };

    final res = await api.post("/api/stock", payload);
    return res.data;
  }
}
