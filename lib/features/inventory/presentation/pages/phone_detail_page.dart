import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phone_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/phone_info_card.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/confirm_dialog.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PhoneDetailPage extends StatelessWidget {
  final String? phoneId;
  final Phone? phone;

  const PhoneDetailPage({super.key, this.phoneId, this.phone});

  Future<dynamic> openPhoneFormSheet(BuildContext context, {Phone? phone}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => PhoneFormBottomSheet(phone: phone),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PhoneController phoneCtrl = Get.find<PhoneController>();
    final CategoryController catCtrl = Get.find<CategoryController>();

    final RxInt activeImageIndex = 0.obs;
    final PageController pageController = PageController();

    return Obx(() {
      final rxPhones = phoneCtrl.phones;
      final bool isLoading = phoneCtrl.isLoading.value;
      final arg = Get.arguments;

      Phone? p;

      // 1) Use updated phone from list
      if (phone != null) {
        p = rxPhones.firstWhereOrNull((x) => x.id == phone!.id) ?? phone;
      }

      // 2) If not found, try id from constructor
      if (p == null && phoneId != null) {
        p = rxPhones.firstWhereOrNull((x) => x.id == phoneId);
      }

      // 3) Try Get.arguments
      if (p == null && arg != null) {
        if (arg is Phone) {
          p = rxPhones.firstWhereOrNull((x) => x.id == arg.id) ?? arg;
        } else if (arg is String) {
          p = rxPhones.firstWhereOrNull((x) => x.id == arg);
        } else if (arg is Map && arg['phone'] is Phone) {
          final argPhone = arg['phone'] as Phone;
          p = rxPhones.firstWhereOrNull((x) => x.id == argPhone.id) ?? argPhone;
        }
      }

      // 4) Auto-fetch missing
      final String? candidateId = phoneId ?? (arg is String ? arg : null);
      if (p == null && candidateId != null && !isLoading) {
        Future.microtask(() => phoneCtrl.fetchPhoneById(candidateId));
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          title: ReusableText(
            text: p != null ? '${p.brand} ${p.model}' : 'Phone detail',
            style: appStyle(16, AppColors.kWhite, FontWeight.w600),
          ),
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.kWhite,
              size: 22.r,
            ),
          ),
          actions: [
            // EDIT
            GestureDetector(
              onTap: () async {
                final updated = await openPhoneFormSheet(context, phone: p);

                if (updated is Phone) {
                  phoneCtrl.updateLocal(updated);
                }
              },
              child: SizedBox(
                width: 35.w,
                height: 35.h,
                child: Icon(Icons.edit, size: 22.r, color: AppColors.kWhite),
              ),
            ),
            SizedBox(width: 12.w),

            // DELETE
            GestureDetector(
              onTap: () async {
                final yes = await showConfirmDialog(
                  title: "Delete Phone",
                  message:
                      "Are you sure you want to delete this phone? This action cannot be undone.",
                  confirmText: "Delete",
                  confirmColor: Colors.red,
                );

                if (yes) {
                  AppSnackbar.success(
                    title: 'Success',
                    message: 'Deleted phone successfully',
                  );
                  phoneCtrl.deletePhone(p!.id!).then(
                    (_) {
                      Get.offAllNamed(
                        Routes.APPSHELL,
                        arguments: {'tab': 1},
                      );
                    },
                  );
                }
              },
              child: SizedBox(
                width: 35.w,
                height: 35.h,
                child: Icon(Icons.delete, size: 22.r, color: AppColors.kRed),
              ),
            ),
            SizedBox(width: 12.w),
          ],
        ),
        body: isLoading && p == null
            ? const Center(child: CircularProgressIndicator())
            : (p == null
                ? _buildNotFound(phoneCtrl)
                : buildPhoneInfoCard(
                    context,
                    p,
                    pageController,
                    activeImageIndex,
                    phoneCtrl,
                    catCtrl,
                  )),
      );
    });
  }

  Widget _buildNotFound(PhoneController phoneCtrl) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40.r, color: Colors.red),
          SizedBox(height: 12.h),
          Text("Phone not found", style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 10.h),
          if (phoneId != null)
            ElevatedButton(
              onPressed: () => phoneCtrl.fetchPhoneById(phoneId!),
              child: Text("Retry fetch", style: TextStyle(fontSize: 12.sp)),
            ),
        ],
      ),
    );
  }
}
