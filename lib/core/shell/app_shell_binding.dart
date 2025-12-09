import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/settings/logic/settings_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
