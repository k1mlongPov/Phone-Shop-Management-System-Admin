import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/features/inventory/data/restock_repository.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';

class RestockController extends GetxController {
  final RestockRepository repo;
  final ApiService api;

  RestockController({required this.repo, required this.api});

  var items = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// From SupplierModel.suppliedProducts
  List<SuppliedProduct> suppliedProducts = [];

  String supplierId = "";
  String note = "";

  /// List<Product for bottom sheet>
  var fetchedProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    addEmptyItem();
  }

  // -----------------------------
  // ADD / UPDATE ROWS
  // -----------------------------

  void addEmptyItem() {
    items.add({
      "productId": null,
      "modelType": null,
      "productName": null,

      // Only for phones
      "variantId": null,
      "variantLabel": null,

      "quantity": 1,
    });
  }

  void updateQuantity(int index, int qty) {
    items[index]["quantity"] = qty;
    items.refresh();
  }

  void updateAccessory({
    required int index,
    required String id,
    required String name,
  }) {
    items[index]["productId"] = id;
    items[index]["modelType"] = "Accessory";
    items[index]["productName"] = name;

    // Clear variant fields
    items[index]["variantId"] = null;
    items[index]["variantLabel"] = null;

    items.refresh();
  }

  void updatePhone({
    required int index,
    required String id,
    required String name,
    required String variantId,
    required String variantLabel,
  }) {
    items[index]["productId"] = id;
    items[index]["modelType"] = "Phone";
    items[index]["productName"] = name;
    items[index]["variantId"] = variantId;
    items[index]["variantLabel"] = variantLabel;

    items.refresh();
  }

  // -----------------------------
  // GET PRODUCTS FOR PICKER
  // -----------------------------
  Future<void> fetchSupplierProductDetails() async {
    fetchedProducts.clear();

    // Deduplicate by productId
    final unique = <String, SuppliedProduct>{};

    for (final p in suppliedProducts) {
      if (p.productId != null) {
        unique[p.productId!] = p; // keeps only one
      }
    }

    final cleanList = unique.values.toList();

    for (final p in cleanList) {
      try {
        final endpoint = p.modelType == "Phone"
            ? "/api/phones/${p.productId}"
            : "/api/accessories/${p.productId}";

        final res = await api.get(endpoint);

        String name;

        if (p.modelType == "Phone") {
          name = res.data["phone"]?["model"] ?? "Unknown Phone";
        } else {
          // Accessory returns name at top-level
          name = res.data["name"] ?? "Unknown Accessory";
        }

        final variants = (res.data["phone"]?["variants"] ?? []).map((v) {
          return {
            "variantId": v["_id"],
            "label": buildVariantLabel(v),
          };
        }).toList();

        fetchedProducts.add({
          "id": p.productId!,
          "name": name,
          "type": p.modelType!,
          "variants": variants ?? [],
        });
      } catch (err) {
        debugPrint("ERROR fetching product ${p.productId}: $err");
      }
    }
  }

  String buildVariantLabel(Map v) {
    final storage = v["storage"] ?? "Unknown";
    final color = v["color"] ?? "";
    final condition = v["condition"] ?? "";
    return "$storage • $color • $condition".trim();
  }

  // -----------------------------
  // SUBMIT RESTOCK
  // -----------------------------
  Future<void> submitRestock() async {
    final valid = items.where((e) => e["productId"] != null).toList();

    if (valid.isEmpty) {
      Get.snackbar("Missing", "Please select at least 1 product");
      return;
    }

    try {
      isLoading(true);

      // Build payload
      final payloadItems = valid.map((e) {
        final map = {
          "productId": e["productId"],
          "modelType": e["modelType"],
          "quantity": e["quantity"],
        };

        if (e["modelType"] == "Phone") {
          map["variantId"] = e["variantId"];
        }

        return map;
      }).toList();

      await repo.restockMany(
        items: payloadItems,
        supplierId: supplierId,
        note: note,
      );
      bool hasPhoneItems = payloadItems.any((e) => e["modelType"] == "Phone");
      bool hasAccessoryItems =
          payloadItems.any((e) => e["modelType"] == "Accessory");

      if (hasPhoneItems) {
        Get.find<PhoneController>().fetchPhones();
      }

      if (hasAccessoryItems) {
        Get.find<AccessoryController>().fetchAccessories();
      }

      Get.back();
      Get.snackbar("Success", "Restock completed");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
