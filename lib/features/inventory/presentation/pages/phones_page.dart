import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/phone_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phone_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/category_filter_widget.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/phone_tile.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_shimmer.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/search_and_filter_widget.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class PhonesPage extends StatelessWidget {
  PhonesPage({super.key});

  final PhoneController phoneCtrl = Get.find<PhoneController>();
  final CategoryController catCtrl = Get.find<CategoryController>();
  final SubCategoryController subCtrl = Get.find<SubCategoryController>();

  final Map<PhoneSortField, String> sortOptions = {
    PhoneSortField.createdAt: 'Newest',
    PhoneSortField.price: 'Price',
    PhoneSortField.brand: 'Brand',
    PhoneSortField.model: 'Model',
    PhoneSortField.stock: 'Stock',
  };

  void openPhoneFormSheet(BuildContext context, {Phone? phone}) {
    showModalBottomSheet(
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
    // ensure subcategories for phones are prefetched
    if (subCtrl.subcategoriesByParent.isEmpty && !subCtrl.isLoading.value) {
      Future.microtask(() => subCtrl.fetchForType('phone'));
    }

    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchAndFilter<PhoneSortField>(
            sortOptions: sortOptions,
            selectedSortField: phoneCtrl.sortField, // Rx<PhoneSortField>
            sortOrder: phoneCtrl.sortOrder, // RxString ('asc'|'desc')
            onSetSortField: (f) => phoneCtrl.setSortField(f),
            onClearSort: () => phoneCtrl.clearSort(),
            onQueryChanged: (s) => phoneCtrl.setQuery(s),
            hintText: 'Search phones...',
          ),

          SizedBox(height: 12.h),

          CategoryFilter(
            parentNameToMatch: 'phone',
            selectedCategoryId: phoneCtrl.selectedCategoryId,
            onSetCategory: (id) => phoneCtrl.setCategoryFilter(id),
          ),

          SizedBox(height: 12.h),

          GestureDetector(
            onTap: () => openPhoneFormSheet(context),
            child: Container(
              margin: EdgeInsets.only(left: 6.w, top: 10.h),
              height: 45.h,
              decoration: BoxDecoration(
                border: Border.all(width: .6, color: AppColors.kPrimary),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.kPrimary,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  ReusableText(
                    text: 'Add new Phone',
                    style: appStyle(14, AppColors.kPrimary, FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // List area — single Obx to avoid nested-obx problems
          Expanded(
            child: Obx(() {
              // error state (prefer showing even when list exists)
              if (phoneCtrl.error.value != null && phoneCtrl.phones.isEmpty) {
                return Center(child: Text('Error: ${phoneCtrl.error.value}'));
              }

              // Loading skeleton when initial loading
              if (phoneCtrl.isLoading.value && phoneCtrl.phones.isEmpty) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: 8,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, __) => const ProductShimmer(),
                );
              }

              // Main list with pull-to-refresh & infinite scroll
              return RefreshIndicator(
                color: AppColors.kPrimary,
                backgroundColor: AppColors.kWhite,
                onRefresh: phoneCtrl.refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                            (notification.metrics.maxScrollExtent - 200) &&
                        !phoneCtrl.isLoadingMore.value &&
                        phoneCtrl.page.value < phoneCtrl.pages.value) {
                      phoneCtrl.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(12.r),
                    itemCount: phoneCtrl.phones.length +
                        (phoneCtrl.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      if (index >= phoneCtrl.phones.length) {
                        // loading more indicator
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final Phone phone = phoneCtrl.phones[index];
                      return PhoneTile(phone: phone);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
