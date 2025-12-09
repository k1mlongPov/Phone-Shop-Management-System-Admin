import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomerInfoSection extends StatelessWidget {
  final Customer customer;

  const CustomerInfoSection({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: "Customer Information",
            style: appStyle(14, AppColors.kDark, FontWeight.w700),
          ),
          SizedBox(height: 14.h),
          _InfoRow(label: "Phone", value: customer.phone),
          _InfoRow(label: "Email", value: customer.email),
          _InfoRow(label: "Address", value: customer.address),
          _InfoRow(label: "Notes", value: customer.notes),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: ReusableText(
              text: label,
              style: appStyle(12, Colors.grey.shade600, FontWeight.w600),
            ),
          ),
          Expanded(
            child: ReusableText(
              text: value == null || value!.isEmpty ? "—" : value!,
              style: appStyle(12, AppColors.kDark, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
