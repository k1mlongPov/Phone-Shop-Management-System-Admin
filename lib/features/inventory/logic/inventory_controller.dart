import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';

class InventoryController extends GetxController {
  final PhoneController phoneCtrl = Get.find<PhoneController>();

  /// current selected tab index
  final selectedIndex = 0.obs;

  Future<Phone?> fetchPhoneById(String id) {
    return phoneCtrl.fetchPhoneById(id, updateList: true);
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
