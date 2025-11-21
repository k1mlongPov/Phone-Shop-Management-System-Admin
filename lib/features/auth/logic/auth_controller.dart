import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/services/local_storage_service.dart';
import 'package:phone_management_system_admin/features/auth/data/auth_repository.dart';
import 'package:phone_management_system_admin/features/auth/domain/models/user_model.dart';

class AuthController extends GetxController {
  AuthController({required this.repository});

  // --- Reactive States ---
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  // --- authenticated user/token ---
  final user = Rxn<UserModel>();
  final token = RxnString();

  final AuthRepository repository;

  // --- Text Controllers ---
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final otp = TextEditingController();
  final phone = TextEditingController();

  // -------------------------------------------------------------
  //                      HELPERS
  // -------------------------------------------------------------

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    if (v.trim().length < 3) return 'Username too short';
    return null;
  }

  void clearLoginFields() {
    email.clear();
    password.clear();
  }

  void clearRegisterFields() {
    username.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
  }

  Future<void> _handleError(dynamic e, String title) async {
    Get.snackbar(title, e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3));
  }

  Future<void> login() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final result = await repository.login(
        email: email.text.trim(),
        password: password.text,
      );

      final loggedUser = result['user'] as UserModel;
      final loggedToken = result['token'] as String;

      user.value = loggedUser;
      token.value = loggedToken;

      // repository.login already persists/attaches token in your repo implementation.
      // If repository.login didn't, call repository.attachToken(loggedToken);

      clearLoginFields();

      Get.offAllNamed(Routes.APPSHELL);
    } catch (e) {
      // You may want to present friendly snackbars here
      final msg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar('Login failed', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  //                   REGISTER (Email)
  // -------------------------------------------------------------

  Future<void> register() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final userMap = await repository.register(
        username: username.text.trim(),
        email: email.text.trim(),
        password: password.text,
      );

      // If repository returns created user object
      if (userMap.isNotEmpty) {
        user.value = UserModel.fromJson(userMap);
      }

      // After register you probably navigate to verification screen
      clearRegisterFields();
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar('Register failed', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  //                     VERIFY EMAIL OTP
  // -------------------------------------------------------------

  Future<void> verifyEmailOtp() async {
    try {
      isLoading.value = true;

      final updated = await repository.verifyPublic(
        email: email.text.trim(),
        otp: otp.text.trim(),
      );

      user.value = updated;

      Get.snackbar("Success", "Email verified! Please login");
      Get.offAllNamed('/login');
    } catch (e) {
      await _handleError(e, "Verification failed");
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  //                       GET CURRENT USER
  // -------------------------------------------------------------

  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;

      final current = await repository.getCurrentUser();
      user.value = current;
    } catch (_) {
      // token invalid -> logout silently
      await logout();
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  //                     BOOTSTRAP ON APP START
  // -------------------------------------------------------------

  Future<void> bootstrap() async {
    final savedToken = await LocalStorageService().getAuthTokenAsync();

    if (savedToken == null || savedToken.isEmpty) return;

    // Token auto-applies via ApiService interceptor
    token.value = savedToken;

    try {
      await fetchCurrentUser();

      if (user.value != null) {
        Get.offAllNamed('/dashboard');
      }
    } catch (_) {
      // Silent fallback
    }
  }

  // -------------------------------------------------------------
  //                    PHONE VERIFY (Optional)
  // -------------------------------------------------------------

  // Future<void> verifyPhoneOtp() async {
  //   try {
  //     isLoading.value = true;

  //     final updated = await repository.verifyPhoneOtp(phone.text.trim());
  //     user.value = updated;

  //     Get.snackbar("Success", "Phone verified");
  //     phone.clear();
  //   } catch (e) {
  //     await _handleError(e, "Phone verify failed");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // -------------------------------------------------------------
  //                        LOGOUT
  // -------------------------------------------------------------

  Future<void> logout() async {
    await repository.logout();

    user.value = null;
    token.value = null;

    Get.offAllNamed('/login');
  }

  // -------------------------------------------------------------
  //                    DISPOSE CONTROLLERS
  // -------------------------------------------------------------

  @override
  void onClose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    otp.dispose();
    phone.dispose();
    super.onClose();
  }
}
