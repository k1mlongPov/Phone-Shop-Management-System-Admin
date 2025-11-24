import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final bool selected;

  const CategoryTile({
    super.key,
    required this.category,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
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
          text: category.name ?? "-",
          style: appStyle(
            14,
            selected ? AppColors.kWhite : AppColors.kDark,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
