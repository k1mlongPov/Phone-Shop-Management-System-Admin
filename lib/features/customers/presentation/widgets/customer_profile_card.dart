import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onEdit;

  const CustomerProfileCard({
    super.key,
    required this.customer,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.width,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                child:
                    Icon(Icons.person, color: AppColors.kPrimary, size: 32.r),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: customer.name,
                    style: appStyle(16, AppColors.kDark, FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text: customer.phone ?? "No phone",
                    style:
                        appStyle(13, Colors.grey.shade700, FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),

          /// Edit Button
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 90.w,
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.kPrimary.withOpacity(.9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 18.r, color: AppColors.kWhite),
                  SizedBox(width: 6.w),
                  ReusableText(
                    text: 'Edit',
                    style: appStyle(12, AppColors.kWhite, FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
