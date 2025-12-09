import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/sales/data/sale_repository.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/sale_item.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/sale_line_item.dart';

class SaleController extends GetxController {
  final SaleRepository repo;

  SaleController({required this.repo});

  // --- CUSTOMER ---
  Rxn<Customer> selectedCustomer = Rxn<Customer>();
  void clearCustomer() => selectedCustomer.value = null;

  RxList<Phone> phones = <Phone>[].obs;
  RxList<Accessory> accessories = <Accessory>[].obs;

  // --- POS CART ---
  RxList<SaleLineItem> items = <SaleLineItem>[].obs;

  // --- TOTALS ---
  RxDouble subtotal = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble tax = 0.0.obs;
  RxDouble total = 0.0.obs;

  RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (items.isEmpty) addLine();
  }

  void resetSale() {
    selectedCustomer.value = null;

    for (final line in items) {
      line.qtyController.dispose();
      line.priceController.dispose();
    }
    items.clear();

    subtotal.value = 0;
    discount.value = 0;
    tax.value = 0;
    total.value = 0;

    addLine();

    // Refresh UI
    items.refresh();
  }

  Future<void> loadProducts() async {
    try {
      final p = await repo.fetchPhones();
      final a = await repo.fetchAccessories();

      phones.assignAll(p);
      accessories.assignAll(a);
    } catch (e) {
      debugPrint("❌ loadProducts error: $e");
    }
  }

  void addLine() {
    items.add(SaleLineItem());
    calculateTotals();
  }

  void removeLine(int index) {
    items.removeAt(index);
    calculateTotals();
  }

  bool isDuplicateProduct({
    required int currentIndex,
    required String productId,
    String? variantId,
  }) {
    for (int i = 0; i < items.length; i++) {
      if (i == currentIndex) continue;

      final line = items[i];

      if (line.productId == productId && line.variantId == variantId) {
        return true;
      }
    }
    return false;
  }

  void increaseQty(int index) {
    final line = items[index];

    int newQty = line.quantity + 1;

    if (newQty > line.availableStock) {
      newQty = line.availableStock;
      Future.delayed(const Duration(milliseconds: 50), () {
        Get.rawSnackbar(
          title: "Stock Limit",
          message: "Only ${line.availableStock} items available!",
          backgroundColor: Colors.red.withOpacity(.9),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      });
    }

    line.quantity = newQty;
    line.qtyController.text = newQty.toString();

    calculateTotals();
    items.refresh();
  }

  void decreaseQty(int index) {
    final line = items[index];

    int newQty = line.quantity - 1;

    if (newQty < 1) newQty = 1;

    line.quantity = newQty;
    line.qtyController.text = newQty.toString();

    calculateTotals();
    items.refresh();
  }

  void setQtyFromInput(int index, int value) {
    final line = items[index];

    int qty = value;

    if (qty < 1) qty = 1;

    if (qty > line.availableStock) {
      qty = line.availableStock;

      Get.rawSnackbar(
        title: "Stock Limit",
        message: "Only ${line.availableStock} items available!",
        backgroundColor: Colors.red.withOpacity(.9),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }

    line.quantity = qty;
    line.qtyController.text = qty.toString();
    line.qtyController.selection = TextSelection.fromPosition(
      TextPosition(offset: line.qtyController.text.length),
    );

    calculateTotals();
    items.refresh();
  }

  void updateQuantity(int index, int qty) {
    items[index].quantity = qty;
    items.refresh();
    calculateTotals();
  }

  void updateUnitPrice(int index, double price) {
    items[index].unitPrice = price;
    items.refresh();
    calculateTotals();
  }

  void updateProductForLine(
    int index, {
    required String productId,
    required String name,
    required String modelType,
    String? variantId,
    String? variantLabel,
    required double price,
    required int stock,
  }) {
    final isDuplicate = isDuplicateProduct(
      currentIndex: index,
      productId: productId,
      variantId: variantId,
    );

    if (isDuplicate) {
      Get.back();
      Future.delayed(const Duration(milliseconds: 50), () {
        Get.snackbar(
          "Duplicate Item",
          "This product is already added!",
          backgroundColor: Colors.orange.withOpacity(.15),
          colorText: Colors.orange.shade900,
        );
      });

      return;
    }

    if (stock == 0) {
      Get.back();
      Future.delayed(const Duration(milliseconds: 50), () {
        Get.rawSnackbar(
          title: "Out of Stock",
          message: "$name is currently out of stock.",
          backgroundColor: Colors.red.withOpacity(.9),
          snackPosition: SnackPosition.TOP,
          borderRadius: 8,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );
      });
      return;
    }

    final line = items[index];

    line.productId = productId;
    line.productName = name;
    line.modelType = modelType;
    line.variantId = variantId;
    line.variantLabel = variantLabel;
    line.unitPrice = price;
    line.availableStock = stock;

    line.priceController.text = price.toString();

    items.refresh();
    calculateTotals();
  }

  void calculateTotals() {
    double sum = 0;
    for (final line in items) {
      sum += line.lineTotal;
    }

    subtotal.value = sum;
    total.value = subtotal.value - discount.value + tax.value;
  }

  Future<InvoiceModel?> submitSale({
    required double paidAmount,
    required String paymentMethod,
    String? notes,
  }) async {
    if (items.isEmpty) return null;

    isSubmitting(true);

    try {
      // Convert SaleLine → SaleItem
      final saleItems = <SaleItem>[];

      for (final line in items) {
        if (line.productId == null) {
          throw "Product not selected for one of the items.";
        }

        if (line.modelType == "Phone" && line.variantId == null) {
          throw "Please select a variant for ${line.productName}";
        }

        saleItems.add(
          SaleItem(
            productId: line.productId!,
            modelType: line.modelType!,
            variantId: line.variantId,
            quantity: line.quantity,
            unitPrice: line.unitPrice,
          ),
        );
      }

      final invoice = await repo.createSale(
        customerId: selectedCustomer.value?.id,
        items: saleItems,
        payment: {
          "method": paymentMethod.toLowerCase(),
          "paidAmount": paidAmount,
        },
        discount: discount.value,
        tax: tax.value,
        notes: notes,
      );

      if (invoice != null) {
        resetSale();
      }

      return invoice;
    } catch (e) {
      debugPrint("❌ submitSale error: $e");
      for (final line in items) {
        debugPrint(
            "DEBUG line: id=${line.productId}, model=${line.modelType}, variant=${line.variantId}");
      }
      return null;
    } finally {
      isSubmitting(false);
    }
  }
}
