import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;
  final ordersBadgeCount = 0.obs;

  void changeIndex(int i) {
    if (i == currentIndex.value) return;
    currentIndex.value = i;
  }

  void incrementOrdersBadge() => ordersBadgeCount.value++;
  void clearOrdersBadge() => ordersBadgeCount.value = 0;
}
