import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SubcategoryTile extends StatelessWidget {
  final CategoryModel category;
  final String parentId;
  final void Function(CategoryModel cat) onEdit;
  final void Function(BuildContext ctx, CategoryModel cat, String parentId)
      onDelete;

  const SubcategoryTile({
    super.key,
    required this.category,
    required this.parentId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(category.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(category),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (_) => onDelete(context, category, parentId),
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
              width: 40.w,
              height: 40.h,
              fit: BoxFit.cover,
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
