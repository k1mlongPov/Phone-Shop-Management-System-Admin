// features/inventory/presentation/pages/accessory_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/routes/app_routes.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessory_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/accessory_widgets/accessory_info_card.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/confirm_dialog.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AccessoryDetailPage extends StatelessWidget {
  final String? accessoryId;
  final Accessory? accessory;

  const AccessoryDetailPage({super.key, this.accessoryId, this.accessory});

  Future<dynamic> openCreateAccessorySheet(
    BuildContext context, {
    Accessory? accessory,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AccessoryFormBottomSheet(accessory: accessory),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AccessoryController accessoryCtrl = Get.find<AccessoryController>();
    final CategoryController catCtrl = Get.find<CategoryController>();

    final RxInt activeImageIndex = 0.obs;
    final PageController pageController = PageController();

    return Obx(
      () {
        final bool isLoading = accessoryCtrl.isLoading.value;

        final arg = Get.arguments;

        // Resolve accessory from: constructor accessory -> constructor id -> Get.arguments -> controller cache
        Accessory? a;

        if (accessory != null) {
          a = accessoryCtrl.accessories
                  .firstWhereOrNull((x) => x.id == accessory!.id) ??
              accessory;
        }

        if (a == null && accessoryId != null) {
          a = accessoryCtrl.accessories
              .firstWhereOrNull((x) => x.id == accessoryId);
        }

        if (a == null && arg != null) {
          if (arg is Accessory) {
            a = accessoryCtrl.accessories
                    .firstWhereOrNull((x) => x.id == arg.id) ??
                arg;
          } else if (arg is String) {
            a = accessoryCtrl.accessories.firstWhereOrNull((x) => x.id == arg);
          } else if (arg is Map && arg['accessory'] is Accessory) {
            final argAcc = arg['accessory'] as Accessory;
            a = accessoryCtrl.accessories
                    .firstWhereOrNull((x) => x.id == argAcc.id) ??
                argAcc;
          }
        }

        // candidate id for auto-fetch attempts
        final String? candidateId = accessoryId ?? (arg is String ? arg : null);

        // If accessory missing and we have an id, show retry / FutureBuilder approach
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.kPrimary,
              leading: GestureDetector(
                onTap: () => Get.back(),
                child:
                    Icon(Icons.arrow_back, color: AppColors.kWhite, size: 22.r),
              ),
              title: ReusableText(
                text: a != null ? (a.name) : 'Accessory detail',
                style: appStyle(16, AppColors.kWhite, FontWeight.w600),
              ),
              actions: [
                // EDIT
                GestureDetector(
                  onTap: () async {
                    final updated =
                        await openCreateAccessorySheet(context, accessory: a);

                    if (updated is Accessory) {
                      accessoryCtrl.updateLocal(updated);
                    }
                  },
                  child: SizedBox(
                    width: 35.w,
                    height: 35.h,
                    child:
                        Icon(Icons.edit, size: 22.r, color: AppColors.kWhite),
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
                      accessoryCtrl.deleteAccessory(a!.id!).then(
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
                    child:
                        Icon(Icons.delete, size: 22.r, color: AppColors.kRed),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
            body: (isLoading && a == null)
                ? const Center(child: CircularProgressIndicator())
                : (a != null
                    ? buildAccessoryInfoCard(
                        context,
                        a,
                        pageController,
                        activeImageIndex,
                        accessoryCtrl,
                        catCtrl,
                      )
                    : _buildMissing(context, candidateId, accessoryCtrl)),
          ),
        );
      },
    );
  }

  Widget _buildMissing(BuildContext context, String? candidateId,
      AccessoryController accessoryCtrl) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40.r, color: Colors.red),
          SizedBox(height: 12.h),
          Text("Accessory not found", style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 10.h),
          if (candidateId != null)
            ElevatedButton(
              onPressed: () {
                // call controller.getById and show result via snackbar or user can navigate back
                accessoryCtrl.fetchAccessoryById(candidateId).then((acc) {
                  if (acc != null) {
                    // try to insert into cached list so detail can pick it up next rebuild
                    accessoryCtrl.accessories.insert(0, acc);
                    accessoryCtrl.accessories.refresh();
                    Get.snackbar('Loaded', 'Accessory fetched');
                  } else {
                    Get.snackbar('Not found', 'Accessory fetch returned null');
                  }
                }).catchError((e) {
                  Get.snackbar('Error', 'Fetch failed: $e');
                });
              },
              child: Text("Retry fetch", style: TextStyle(fontSize: 12.sp)),
            ),
        ],
      ),
    );
  }
}
