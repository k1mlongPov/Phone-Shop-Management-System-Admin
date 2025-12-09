import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:phone_management_system_admin/features/dashboard/domain/models/restock_entry.dart';
import 'package:phone_management_system_admin/features/dashboard/domain/models/top_selling_item.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';

class DashboardController extends GetxController {
  final DashboardRepository repo;

  DashboardController({required this.repo});

  RxList<Phone> lowStockPhones = <Phone>[].obs;
  RxList<Accessory> lowStockAccessories = <Accessory>[].obs;

  RxList<Phone> outStockPhones = <Phone>[].obs;
  RxList<Accessory> outStockAccessories = <Accessory>[].obs;

  RxList<RestockEntry> entries = <RestockEntry>[].obs;
  RxList<TopSellingItem> weeklyTopSelling = <TopSellingItem>[].obs;
  RxList<TopSellingItem> monthlyTopSelling = <TopSellingItem>[].obs;

  RxDouble todaySales = 0.0.obs;
  RxInt todayInvoices = 0.obs;
  RxInt newCustomersToday = 0.obs;
  RxString topMode = "weekly".obs;

  RxList<double> phoneRevenue7Days = List<double>.filled(7, 0).obs;
  RxList<double> accessoryRevenue7Days = List<double>.filled(7, 0).obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    loadHistory();
    load7DayRevenue();
  }

  Future<void> load7DayRevenue() async {
    try {
      final data = await repo.fetchSevenDayRevenue();

      phoneRevenue7Days.assignAll(
        data["phone"]!.isEmpty ? List<double>.filled(7, 0) : data["phone"]!,
      );

      accessoryRevenue7Days.assignAll(
        data["accessory"]!.isEmpty
            ? List<double>.filled(7, 0)
            : data["accessory"]!,
      );
    } catch (e) {
      debugPrint("Revenue 7-day load error: $e");
    }
  }

  Future<void> loadDashboard() async {
    isLoading(true);
    try {
      final res = await repo.fetchDashboardStats();
      final data = res["data"];

      lowStockPhones.assignAll(
        (data["stock"]["low"]["phones"] as List)
            .map((e) => Phone.fromJson(e))
            .toList(),
      );

      lowStockAccessories.assignAll(
        (data["stock"]["low"]["accessories"] as List)
            .map((e) => Accessory.fromJson(e))
            .toList(),
      );

      outStockPhones.assignAll(
        (data["stock"]["outOfStock"]["phones"] as List)
            .map((e) => Phone.fromJson(e))
            .toList(),
      );

      outStockAccessories.assignAll(
        (data["stock"]["outOfStock"]["accessories"] as List)
            .map((e) => Accessory.fromJson(e))
            .toList(),
      );

      weeklyTopSelling.assignAll(
        (data["topSelling"]["weekly"] as List)
            .map((e) => TopSellingItem.fromJson(e))
            .toList(),
      );

      monthlyTopSelling.assignAll(
        (data["topSelling"]["monthly"] as List)
            .map((e) => TopSellingItem.fromJson(e))
            .toList(),
      );

      todaySales.value = (data["today"]["sales"] as num).toDouble();
      todayInvoices.value = data["today"]["invoices"] ?? 0;
      newCustomersToday.value = data["today"]["newCustomers"] ?? 0;
    } catch (e) {
      debugPrint("Dashboard load error: $e");
    } finally {
      isLoading(false);
    }
  }

  int get lowStockCount => lowStockPhones.length + lowStockAccessories.length;

  int get outStockCount => outStockPhones.length + outStockAccessories.length;

  Future<void> loadHistory() async {
    try {
      isLoading(true);
      final list = await repo.fetchRestockHistory();
      entries.assignAll(list);
    } catch (e) {
      debugPrint("❌ Restock history load error: $e");
    } finally {
      isLoading(false);
    }
  }
}
