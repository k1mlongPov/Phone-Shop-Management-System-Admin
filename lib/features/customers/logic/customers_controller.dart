import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/customers/data/customer_repository.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';

class CustomersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CustomersRepository repo;

  CustomersController({required this.repo});

  late final TabController tabController;

  // ----------------- DATA -----------------
  final customers = <Customer>[].obs;
  final customersUsers = <UserModel>[].obs;
  final staff = <UserModel>[].obs;
  final admins = <UserModel>[].obs;

  final filteredList = <dynamic>[].obs;

  final searchQuery = ''.obs;

  final isLoading = false.obs;

  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_onTabChange);

    loadTabData();
  }

  void _onTabChange() {
    if (!tabController.indexIsChanging) {
      tabIndex.value = tabController.index;
      loadTabData();
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Public refresh
  // ---------------------------------------------------------------------------
  Future<void> refreshData() async {
    await loadTabData();
  }

  // ---------------------------------------------------------------------------
  // Load data per tab
  // ---------------------------------------------------------------------------
  Future<void> loadTabData() async {
    isLoading(true);
    try {
      switch (tabIndex.value) {
        case 0:
          await _loadCustomersTab();
          break;
        case 1:
          await _loadStaffTab();
          break;
        case 2:
          await _loadAdminsTab();
          break;
      }
    } catch (e) {
      debugPrint("❌ loadTabData error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadCustomersTab() async {
    final list1 = await repo.fetchCustomers();
    final list2 = await repo.fetchUsersByRole("Customer");

    customers.assignAll(list1);
    customersUsers.assignAll(list2);

    _applyCustomersFilter();
  }

  Future<void> _loadStaffTab() async {
    final list = await repo.fetchUsersByRole("Staff");
    staff.assignAll(list);
    _applyStaffFilter();
  }

  Future<void> _loadAdminsTab() async {
    final list = await repo.fetchUsersByRole("Admin");
    admins.assignAll(list);
    _applyAdminsFilter();
  }

  // ---------------------------------------------------------------------------
  // Filtering / Search
  // ---------------------------------------------------------------------------
  void search(String value) {
    searchQuery.value = value.toLowerCase().trim();

    switch (tabIndex.value) {
      case 0:
        _applyCustomersFilter();
        break;
      case 1:
        _applyStaffFilter();
        break;
      case 2:
        _applyAdminsFilter();
        break;
    }
  }

  void _applyCustomersFilter() {
    final q = searchQuery.value;

    if (q.isEmpty) {
      filteredList.assignAll([...customers, ...customersUsers]);
    } else {
      filteredList.assignAll([
        ...customers.where((c) =>
            c.name.toLowerCase().contains(q) ||
            (c.phone?.toLowerCase().contains(q) ?? false)),
        ...customersUsers.where((u) =>
            u.username.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q)),
      ]);
    }
  }

  void _applyStaffFilter() {
    final q = searchQuery.value;

    if (q.isEmpty) {
      filteredList.assignAll(staff);
    } else {
      filteredList.assignAll(
        staff.where((u) =>
            u.username.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q)),
      );
    }
  }

  void _applyAdminsFilter() {
    final q = searchQuery.value;

    if (q.isEmpty) {
      filteredList.assignAll(admins);
    } else {
      filteredList.assignAll(
        admins.where((u) =>
            u.username.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q)),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  Customer? findCustomerById(String id) {
    try {
      return customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Create customer
  // ---------------------------------------------------------------------------
  Future<void> createCustomer(Customer model) async {
    isLoading(true);
    try {
      final created = await repo.createCustomer(model);
      if (created != null) {
        customers.insert(0, created);

        if (tabIndex.value == 0) {
          _applyCustomersFilter();
        }
      }
    } catch (e) {
      debugPrint("❌ createCustomer error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // Update customer
  // ---------------------------------------------------------------------------
  Future<void> updateCustomer(String id, Map<String, dynamic> payload) async {
    isLoading(true);
    try {
      final updated = await repo.updateCustomer(id, payload);
      if (updated != null) {
        final index = customers.indexWhere((c) => c.id == id);
        if (index != -1) {
          customers[index] = updated;
        } else {
          customers.insert(0, updated);
        }

        if (tabIndex.value == 0) {
          _applyCustomersFilter();
        }
      }
    } catch (e) {
      debugPrint("❌ updateCustomer error: $e");
    } finally {
      isLoading(false);
    }
  }
}
