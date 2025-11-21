import 'package:get/get.dart';

class DashboardController extends GetxController {
  // KPI
  final todaySales = 0.0.obs;
  final todayInvoices = 0.obs;
  final lowStockCount = 0.obs;
  final newCustomersToday = 0.obs;

  // Top selling this week
  final topSelling = <Map<String, dynamic>>[
    {'name': 'iPhone 14', 'qty': 15},
    {'name': 'Galaxy S23', 'qty': 12},
    {'name': 'Redmi Note 12', 'qty': 10},
  ].obs;

  // Recent sales invoices
  final recentSales = <Map<String, dynamic>>[
    {'id': 'INV-00112', 'amount': 899, 'customer': 'Sok', 'date': 'Today'},
    {'id': 'INV-00111', 'amount': 1200, 'customer': 'Vann', 'date': 'Today'},
  ].obs;

  // Warranty expiring
  final warrantyExpiring = <String>[
    'Vivo Y22 - Warranty ends in 3 days',
    'iPhone 13 - Warranty ends in 5 days'
  ].obs;

  // Repairs
  final repairsInProgress = <Map<String, String>>[
    {'model': 'iPhone X', 'status': 'Diagnostics'},
    {'model': 'OPPO Reno6', 'status': 'Waiting for parts'},
  ].obs;

  Future<void> refreshDashboard() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Call your local DB or API to refresh values
    todaySales.value = 1500.00;
    todayInvoices.value = 12;
    lowStockCount.value = 4;
    newCustomersToday.value = 2;
  }
}
