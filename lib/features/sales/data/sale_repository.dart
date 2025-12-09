import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/sale_item.dart';

class SaleRepository {
  final ApiService api;

  SaleRepository({required this.api});

  Future<List<Phone>> fetchPhones() async {
    final res = await api.get("/api/phones");
    return (res.data["data"] as List).map((e) => Phone.fromJson(e)).toList();
  }

  Future<List<Accessory>> fetchAccessories() async {
    final res = await api.get("/api/accessories");
    return (res.data["data"] as List)
        .map((e) => Accessory.fromJson(e))
        .toList();
  }

  /// Create a sale invoice
  Future<InvoiceModel?> createSale({
    String? customerId,
    Map<String, dynamic>? walkInCustomer,
    required List<SaleItem> items,
    required Map<String, dynamic> payment,
    double discount = 0,
    double tax = 0,
    String? notes,
  }) async {
    final payload = {
      if (customerId != null) "customerId": customerId,
      if (walkInCustomer != null) "walkInCustomer": walkInCustomer,
      "items": items.map((e) => e.toJson()).toList(),
      "payment": payment,
      "discount": discount,
      "tax": tax,
      if (notes != null) "notes": notes,
    };

    final res = await api.post("/api/sales", payload);

    if (res.data["success"] != true) return null;

    try {
      return InvoiceModel.fromJson(res.data["data"]);
    } catch (e) {
      debugPrint("❌ InvoiceModel parse error: $e");
      debugPrint("❌ RAW DATA THAT FAILED: ${res.data["data"]}");
      rethrow;
    }
  }

  /// Fetch invoice by ID
  Future<InvoiceModel?> getInvoice(String id) async {
    final res = await api.get("/api/sales/$id");

    if (res.data["success"] != true) return null;

    return InvoiceModel.fromJson(res.data["data"]);
  }

  /// List all invoices (paginated)
  Future<List<InvoiceModel>> listInvoices({int page = 1}) async {
    final res = await api.get("/api/sales", query: {"page": page});

    if (res.data["success"] != true) return [];

    return (res.data["items"] as List)
        .map((e) => InvoiceModel.fromJson(e))
        .toList();
  }
}
