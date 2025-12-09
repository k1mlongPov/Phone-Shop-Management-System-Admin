import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';
import 'package:phone_management_system_admin/features/sales/data/invoice_history_repository.dart';

class InvoiceHistoryController extends GetxController {
  final InvoiceHistoryRepository repo;

  InvoiceHistoryController({required this.repo});

  RxList<InvoiceModel> invoices = <InvoiceModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    isLoading(true);
    try {
      invoices.assignAll(await repo.fetchInvoices());
    } catch (e) {
      print("❌ Failed loading invoices: $e");
    } finally {
      isLoading(false);
    }
  }
}
