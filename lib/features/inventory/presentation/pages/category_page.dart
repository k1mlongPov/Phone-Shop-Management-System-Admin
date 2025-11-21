import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_shimmer.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final CategoryController catCtrl = Get.find<CategoryController>();
  final SubCategoryController subCtrl = Get.find<SubCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
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

                  return Obx(() {
                    final bool isSelected =
                        subCtrl.activeParentId.value == (parent.id ?? '');

                    return GestureDetector(
                      onTap: () {
                        subCtrl.setActiveParent(parent.id ?? '');
                      },
                      child: _buildCategoryTile(parent, isSelected),
                    );
                  });
                },
              ),
            );
          }),
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
                onRefresh: () async {
                  await subCtrl.refetchSubcategories(parentId);
                },
                child: ListView.separated(
                  padding: EdgeInsets.all(12.r),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return _buildSubcategoryTile(
                      context,
                      list[index],
                      parentId,
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

  // ------------------------------------------------------------------------
  // CATEGORY TILE
  // ------------------------------------------------------------------------
  Widget _buildCategoryTile(CategoryModel cat, bool selected) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: selected ? AppColors.kPrimary : AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: selected ? AppColors.kPrimary : Colors.grey.shade400,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .08),
            blurRadius: 6,
            offset: Offset(1, 2),
          )
        ],
      ),
      child: Center(
        child: ReusableText(
          text: cat.name ?? "-",
          style: appStyle(
            14,
            selected ? AppColors.kWhite : AppColors.kDark,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryShimmer() {
    return Container(
      width: 120.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }

  Widget _buildSubcategoryTile(
      BuildContext context, CategoryModel cat, String parentId) {
    return Slidable(
      key: ValueKey(cat.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _onEdit(cat),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (_) => _onDelete(context, cat, parentId),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Container(
        width: AppSize.width,
        height: 70.h,
        decoration: const BoxDecoration(
          color: AppColors.kWhite,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Center(
          child: ListTile(
            leading: Image.network(
              cat.image!,
              width: 40.w,
              height: 40.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image,
                size: 40.r,
              ),
            ),
            title: ReusableText(
              text: cat.name ?? '',
              style: appStyle(14, AppColors.kDark, FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDelete(
      BuildContext context, CategoryModel c, String parentId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Subcategory"),
        content: Text('Are you sure you want to delete "${c.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await catCtrl.deleteCategory(c.id ?? '');
        await subCtrl.refetchSubcategories(parentId);
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  void _onEdit(CategoryModel c) {
    Get.toNamed('/categories/edit', arguments: c);
  }
}
