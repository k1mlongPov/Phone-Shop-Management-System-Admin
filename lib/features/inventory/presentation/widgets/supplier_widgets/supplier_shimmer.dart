import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';

class SupplierShimmer extends StatelessWidget {
  const SupplierShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.width,
      height: 70.h,
      margin: EdgeInsets.symmetric(vertical: 6.h),
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
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          leading: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          title: Container(
            width: 150.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 120.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          trailing: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ),
      ),
    );
  }
}
