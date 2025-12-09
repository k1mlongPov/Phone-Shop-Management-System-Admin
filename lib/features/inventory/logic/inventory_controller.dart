import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final selectedIndex = 0.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 4, vsync: this);

    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }

  void changeTab(int index) {
    tabController.animateTo(index);
    selectedIndex.value = index;
  }
}
