import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/category_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/category_widgets/category_tile.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/category_widgets/subcategory_tile.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_shimmer.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final CategoryController catCtrl = Get.find<CategoryController>();
  final SubCategoryController subCtrl = Get.find<SubCategoryController>();

  Future<void> openCreateCategorySheet(
    BuildContext context, {
    CategoryModel? category,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CategoryFormBottomSheet(),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              if (catCtrl.isLoadingRoot.value) {
                return SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (_, __) => const ProductShimmer(),
                  ),
                );
              }

              final parents = catCtrl.rootCategories;

              return SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: parents.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final parent = parents[i];

                    return Obx(
                      () {
                        final bool isSelected =
                            subCtrl.activeParentId.value == (parent.id ?? '');

                        return GestureDetector(
                          onTap: () {
                            subCtrl.setActiveParent(parent.id ?? '');
                          },
                          child: CategoryTile(
                            category: parent,
                            selected: isSelected,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () => openCreateCategorySheet(context),
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
                    text: 'Add new subcategory',
                    style: appStyle(14, AppColors.kPrimary, FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Obx(() {
              final parentId = subCtrl.activeParentId.value;

              if (parentId.isEmpty) {
                return const Center(child: Text("Select a category"));
              }

              final list = subCtrl.getSubcategories(parentId);

              if (subCtrl.isLoading.value && list.isEmpty) {
                return const ProductShimmer();
              }

              if (list.isEmpty) {
                return const Center(child: Text("No subcategories found"));
              }

              return RefreshIndicator(
                backgroundColor: AppColors.kWhite,
                color: AppColors.kPrimary,
                onRefresh: () async {
                  await subCtrl.refetchSubcategories(parentId);
                },
                child: ListView.separated(
                  padding: EdgeInsets.all(12.r),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return SubcategoryTile(
                      category: list[index],
                      parentId: parentId,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
