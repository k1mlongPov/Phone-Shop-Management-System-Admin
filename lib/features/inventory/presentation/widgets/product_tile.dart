import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ListTile(
        leading: Image.network(
          image,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.broken_image,
            size: 40.r,
          ),
        ),
        title: ReusableText(
          text: title,
          style: appStyle(14, AppColors.kDark, FontWeight.w600),
        ),
        subtitle: ReusableText(
          text: subtitle,
          style: appStyle(12, AppColors.kPrimary, FontWeight.normal),
        ),
        trailing: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50.w,
            height: 50.h,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
            ),
          ),
        ),
      ),
    );
  }
}
