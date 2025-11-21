// features/inventory/presentation/widgets/category_filter.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

typedef SetCategoryFn = void Function(String? id);

class CategoryFilter extends StatelessWidget {
  /// Name to match on top-level parent category (e.g. "phone", "accessory").
  /// If null, the widget will use CategoryController.subcategories as fallback.
  final String? parentNameToMatch;

  /// Reactive selected category id (e.g. PhoneController.selectedCategoryId).
  final RxString selectedCategoryId;

  /// Function to call when user picks a category (pass null to clear).
  final SetCategoryFn onSetCategory;

  /// Optionally provide controllers (otherwise Get.find is used).
  final CategoryController? categoryController;
  final SubCategoryController? subCategoryController;

  final String allLabel;
  final double heightFraction;

  const CategoryFilter({
    super.key,
    required this.selectedCategoryId,
    required this.onSetCategory,
    this.parentNameToMatch,
    this.categoryController,
    this.subCategoryController,
    this.allLabel = 'All categories',
    this.heightFraction = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final catCtrl = categoryController ?? Get.find<CategoryController>();
    final subCtrl = subCategoryController ?? Get.find<SubCategoryController>();

    return Obx(() {
      // compute parent id by matching root category name (case-insensitive)
      final String? parentIdNullable = parentNameToMatch == null
          ? null
          : catCtrl.rootCategories
              .firstWhereOrNull(
                (c) => (c.name ?? '')
                    .toLowerCase()
                    .contains(parentNameToMatch!.toLowerCase()),
              )
              ?.id;

      // If we have a parent id and its subcategories are not loaded, request them.
      if (parentIdNullable != null &&
          parentIdNullable.isNotEmpty &&
          !subCtrl.subcategoriesByParent.containsKey(parentIdNullable) &&
          !subCtrl.isLoading.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          subCtrl.fetchSubcategories(parentIdNullable);
        });
      }

      // pick the visible sub list (either subCtrl cache for parent, or catCtrl.subcategories)
      final List subs =
          (parentIdNullable != null && parentIdNullable.isNotEmpty)
              ? subCtrl.getSubcategories(parentIdNullable)
              : catCtrl.subcategories;

      final selectedId = selectedCategoryId.value;
      final selectedName = selectedId.isEmpty
          ? allLabel
          : (subs.firstWhereOrNull((c) => (c?.id ?? '') == selectedId)?.name ??
              'Selected');

      return GestureDetector(
        onTap: () =>
            _showCategorySheet(context, catCtrl, subCtrl, parentIdNullable),
        child: Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            border: Border.all(width: 0.6, color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: ReusableText(
                  text: selectedName,
                  style: appStyle(14, AppColors.kGray, FontWeight.w400),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      );
    });
  }

  void _showCategorySheet(
    BuildContext context,
    CategoryController catCtrl,
    SubCategoryController subCtrl,
    String? parentId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * heightFraction,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 8.h),
                ReusableText(
                  text: 'Categories',
                  style: appStyle(16, AppColors.kDark, FontWeight.w400),
                ),
                Divider(height: 16.h),
                ListTile(
                  title: ReusableText(
                    text: allLabel,
                    style: appStyle(12, AppColors.kDark, FontWeight.normal),
                  ),
                  trailing: selectedCategoryId.value.isEmpty
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSetCategory(null);
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 1),
                Expanded(
                  child: Obx(() {
                    // prefer subCtrl list when parentId known
                    if (parentId != null && parentId.isNotEmpty) {
                      if (subCtrl.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final subs = subCtrl.getSubcategories(parentId);
                      if (subs.isEmpty) {
                        final available = catCtrl.rootCategories
                            .map((c) => c.name)
                            .where((n) => n != null)
                            .join(', ');
                        return Center(
                            child: Text(
                                'No categories. Available roots: $available'));
                      }
                      return ListView.separated(
                        itemCount: subs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = subs[index];
                          final isSelected =
                              selectedCategoryId.value == (c.id ?? '');
                          return ListTile(
                            title: ReusableText(
                                text: c.name ?? '',
                                style: appStyle(
                                    12, AppColors.kDark, FontWeight.normal)),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                            onTap: () {
                              onSetCategory((c.id ?? '').isEmpty ? null : c.id);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    } else {
                      // fallback: use categoryController.subcategories
                      if (catCtrl.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final subs = catCtrl.subcategories;
                      if (subs.isEmpty) {
                        return const Center(child: Text('No categories'));
                      }
                      return ListView.separated(
                        itemCount: subs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = subs[index];
                          final isSelected =
                              selectedCategoryId.value == (c.id ?? '');
                          return ListTile(
                            title: ReusableText(
                              text: c.name ?? '',
                              style: appStyle(
                                  12, AppColors.kGray, FontWeight.w400),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                            onTap: () {
                              onSetCategory((c.id ?? '').isEmpty ? null : c.id);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
