import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/phone_info_card.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PhoneDetailPage extends StatelessWidget {
  final String? phoneId;
  final Phone? phone;

  const PhoneDetailPage({super.key, this.phoneId, this.phone});

  @override
  Widget build(BuildContext context) {
    final PhoneController phoneCtrl = Get.find<PhoneController>();
    final CategoryController catCtrl = Get.find<CategoryController>();

    // Keep a reactive int for the image index that the indicator Obx will read.
    final RxInt activeImageIndex = 0.obs;
    final PageController pageController = PageController();

    return Obx(
      () {
        final rxPhones = phoneCtrl.phones;
        final bool isLoading = phoneCtrl.isLoading.value;
        final arg = Get.arguments;
        Phone? p;

        // 1) If constructor phone provided, prefer an updated version from rxPhones
        if (phone != null) {
          p = rxPhones.firstWhereOrNull((x) => x.id == phone!.id) ?? phone;
        }

        // 2) If not resolved and phoneId constructor param provided
        if (p == null && phoneId != null) {
          p = rxPhones.firstWhereOrNull((x) => x.id == phoneId);
        }

        // 3) If still not resolved, check Get.arguments (could be id string, Phone, or map)
        if (p == null && arg != null) {
          if (arg is Phone) {
            p = rxPhones.firstWhereOrNull((x) => x.id == arg.id) ?? arg;
          } else if (arg is String) {
            p = rxPhones.firstWhereOrNull((x) => x.id == arg);
          } else if (arg is Map && arg['phone'] is Phone) {
            final argPhone = arg['phone'] as Phone;
            p = rxPhones.firstWhereOrNull((x) => x.id == argPhone.id) ??
                argPhone;
          }
        }

        // 4) AUTO-FETCH: if we have a phoneId (constructor) or arg string id and phone is missing, fetch once
        // Prevent repeated calls by checking isLoading
        final String? candidateId = phoneId ?? (arg is String ? arg : null);
        if (p == null && candidateId != null && !isLoading) {
          // schedule async fetch after build completes
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
      },
    );
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
