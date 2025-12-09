import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';

class InvoiceHistoryRepository {
  final ApiService api;
  InvoiceHistoryRepository({required this.api});

  Future<List<InvoiceModel>> fetchInvoices() async {
    final res = await api.get("/api/sales");

    final list = res.data["data"] as List;
    return list.map((e) => InvoiceModel.fromJson(e)).toList();
  }

  Future<InvoiceModel?> fetchInvoiceById(String id) async {
    final res = await api.get("/api/sales/$id");

    return InvoiceModel.fromJson(res.data["data"]);
  }
}
