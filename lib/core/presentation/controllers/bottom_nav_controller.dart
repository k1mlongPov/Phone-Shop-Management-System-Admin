import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;
  final ordersBadgeCount = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['tab'] != null) {
      currentIndex.value = Get.arguments['tab'];
    }
    super.onInit();
  }

  void changeIndex(int i) {
    if (i == currentIndex.value) return;
    currentIndex.value = i;
  }

  void incrementOrdersBadge() => ordersBadgeCount.value++;
  void clearOrdersBadge() => ordersBadgeCount.value = 0;
}
