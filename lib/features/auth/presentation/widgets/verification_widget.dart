import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_button.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:pinput/pinput.dart';

class VerificationWidget extends StatefulWidget {
  final String text;
  final String email;
  final VoidCallback? onSuccess;

  const VerificationWidget({
    super.key,
    required this.text,
    required this.email,
    this.onSuccess,
  });

  @override
  State<VerificationWidget> createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  bool _submitting = false;
  String? _error;
  late final AuthController _authC;

  @override
  void initState() {
    super.initState();
    _authC = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _submitOtp() async {
    final enteredOtp = _pinController.text.trim();
    final email = widget.email.trim();

    if (enteredOtp.isEmpty) {
      setState(() => _error = 'Please enter the code');
      return;
    }
    if (email.isEmpty) {
      setState(() => _error = 'Missing email');
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });

    try {
      debugPrint(
          'Submitting OTP verify -> email: "$email", otp: "$enteredOtp"');

      // call repository directly to avoid mismatch with controller fields
      final updatedUser = await _authC.repository.verifyPublic(
        email: email,
        otp: enteredOtp,
      );

      debugPrint('Verify success: user=${updatedUser.toString()}');

      // optional: if you want to update controller user state
      _authC.user.value = updatedUser;

      _pinController.clear();
      widget.onSuccess?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
    } catch (e, st) {
      String friendly = 'Verification failed';
      try {
        if (e is DioException) {
          final server = e.response?.data;
          debugPrint('DioException response: ${e.response}');
          if (server is Map && server['message'] != null) {
            friendly = server['message'].toString();
          } else if (server is String) {
            friendly = server;
          } else {
            friendly = e.message ?? friendly;
          }
        } else {
          friendly = e.toString().replaceAll('Exception: ', '');
        }
      } catch (_) {
        friendly = e.toString();
      }

      debugPrint('OTP submit error: $e\n$st');
      setState(() => _error = friendly);
    } finally {
      setState(() => _submitting = false);
    }
  }

  Future<void> _resendOtp() async {
    final email = widget.email.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Missing email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      setState(() => _submitting = true);
      debugPrint('Requesting resend OTP for email: "$email"');

      await _authC.repository.requestResendOtp(email: email);

      Get.snackbar('Sent', 'Verification code resent',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e, st) {
      String friendly = 'Resend failed';
      try {
        if (e is DioException) {
          final server = e.response?.data;
          if (server is Map && server['message'] != null) {
            friendly = server['message'].toString();
          } else if (server is String) {
            friendly = server;
          } else {
            friendly = e.message ?? friendly;
          }
        } else {
          friendly = e.toString().replaceAll('Exception: ', '');
        }
      } catch (_) {
        friendly = e.toString();
      }

      debugPrint('Resend OTP error: $e\n$st');
      Get.snackbar('Resend failed', friendly,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      textStyle: appStyle(20, AppColors.kDark, FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.kGray),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_sharp,
                        size: 20.r,
                      ),
                      onTap: () => Get.back(),
                    ),
                    SizedBox(width: 5.w),
                    ReusableText(
                      text: 'Back',
                      style: appStyle(14, AppColors.kDark, FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: ReusableText(
                    text: 'Enter your OTP code',
                    style: appStyle(22, AppColors.kDark, FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: ReusableText(
                    textAlign: TextAlign.center,
                    text:
                        'Please check your email the verification code has sent to ${widget.email.toString()}',
                    style: appStyle(14, AppColors.kDark, FontWeight.normal),
                    maxLine: 3,
                  ),
                ),
                SizedBox(height: 10.h),
                // ... top row/back button omitted for brevity (keep from your original)
                SizedBox(height: 18.h),
                Pinput(
                  controller: _pinController,
                  focusNode: _pinFocus,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  keyboardType: TextInputType.number,
                ),
                if (_error != null) ...[
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReusableText(
                      text: _error!,
                      style: appStyle(12, Colors.red, FontWeight.w600),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ReusableText(
                        text: "Didn't receive the code? ",
                        style:
                            appStyle(14, AppColors.kDark, FontWeight.normal)),
                    GestureDetector(
                      onTap: _resendOtp,
                      child: ReusableText(
                        text: 'Resend',
                        style: appStyle(14, AppColors.kPrimary.withOpacity(0.8),
                            FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: _submitting ? 'Submitting...' : 'Submit',
                  btnHeight: 40.h,
                  radius: 20.r,
                  onTap: _submitting ? null : _submitOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
