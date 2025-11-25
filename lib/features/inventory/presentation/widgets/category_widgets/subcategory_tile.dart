import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/category_form_bottom_sheet.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/confirm_dialog.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SubcategoryTile extends StatelessWidget {
  final CategoryModel category;
  final String parentId;

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
      builder: (_) => CategoryFormBottomSheet(category: category),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      ),
    );
  }

  const SubcategoryTile({
    super.key,
    required this.category,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    final catCtrl = Get.find<CategoryController>();
    final subCtrl = Get.find<SubCategoryController>();
    return Slidable(
      key: ValueKey(category.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                openCreateCategorySheet(context, category: category),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (_) async {
              final yes = await showConfirmDialog(
                title: "Delete Phone",
                message:
                    "Are you sure you want to delete this phone? This action cannot be undone.",
                confirmText: "Delete",
                confirmColor: Colors.red,
              );
              await catCtrl.deleteCategory(category.id!);

              await subCtrl.refetchSubcategories(parentId);

              if (yes) {
                AppSnackbar.success(
                  title: 'Success',
                  message: 'Deleted phone successfully',
                );
              }
              if (!yes) return;
            },
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
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 2,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Center(
          child: ListTile(
            leading: Image.network(
              category.image ?? "",
              width: 60.w,
              height: 40.h,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.broken_image, size: 40.r),
            ),
            title: ReusableText(
              text: category.name ?? '',
              style: appStyle(14, AppColors.kDark, FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
