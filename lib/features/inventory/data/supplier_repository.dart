import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';

class SupplierRepository {
  final ApiService api;

  SupplierRepository({required this.api});

  Future<List<SupplierModel>> fetchSuppliers() async {
    final res = await api.get('/api/suppliers');

    final body = res.data;

    if (body is Map && body['data'] is List) {
      final List list = body['data'];
      return list.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        return SupplierModel.fromJson(map);
      }).toList();
    }

    return [];
  }

  Future<SupplierModel> createSupplier(Map<String, dynamic> payload) async {
    final res = await api.post('/api/suppliers', payload);

    final body = res.data;

    if (body is Map && body['data'] is Map) {
      return SupplierModel.fromJson(
        Map<String, dynamic>.from(body['data']),
      );
    }

    throw Exception("Invalid create supplier response");
  }

  Future<SupplierModel> updateSupplier(
      String id, Map<String, dynamic> payload) async {
    final res = await api.put('/api/suppliers/$id', payload);

    final body = res.data;

    if (body is Map && body['data'] is Map) {
      return SupplierModel.fromJson(
        Map<String, dynamic>.from(body['data']),
      );
    }

    throw Exception("Invalid update supplier response");
  }

  Future<bool> deleteSupplier(String id) async {
    final res = await api.delete('/api/suppliers/$id');

    final body = res.data;

    return body is Map && body['success'] == true;
  }

  Future<SupplierModel?> getSupplierById(String id) async {
    final res = await api.get('/api/suppliers/$id');

    final body = res.data;

    if (body is Map && body['data'] is Map) {
      return SupplierModel.fromJson(
        Map<String, dynamic>.from(body['data']),
      );
    }

    return null;
  }
}
