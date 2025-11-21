import 'package:get/get.dart';

class SwitchController extends GetxController {
  var isSwitch = true.obs;

  void toggleToLeft() => isSwitch.value = true;
  void toggleToRight() => isSwitch.value = false;
}
