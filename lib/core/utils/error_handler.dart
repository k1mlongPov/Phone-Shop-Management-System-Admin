import 'package:get/get.dart';

class ErrorHandler {
  static void handle(Object error) {
    final message = _mapError(error);
    Get.snackbar('Error', message);
  }

  static String _mapError(Object e) {
    return 'Something went wrong. Please try again.';
  }
}
