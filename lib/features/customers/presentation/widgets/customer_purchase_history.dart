import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomerPurchaseHistory extends StatelessWidget {
  final Customer customer;

  const CustomerPurchaseHistory({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat("MMM dd, yyyy hh:mm a");

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
            text: "Purchase History",
            style: appStyle(14, AppColors.kDark, FontWeight.w700),
          ),
          SizedBox(height: 10.h),
          if (customer.purchaseHistory.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: ReusableText(
                  text: "No purchases yet",
                  style: appStyle(12, Colors.grey.shade600, FontWeight.normal),
                ),
              ),
            )
          else
            ...customer.purchaseHistory.map(
              (item) => _PurchaseTile(item: item, fmt: fmt),
            ),
        ],
      ),
    );
  }
}

class _PurchaseTile extends StatelessWidget {
  final PurchaseHistoryItem item;
  final DateFormat fmt;

  const _PurchaseTile({required this.item, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isPhone = item.modelType == "Phone";

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isPhone
                ? AppColors.kPrimary.withOpacity(0.1)
                : Colors.purple.withOpacity(0.1),
            child: Icon(
              isPhone ? Icons.phone_android : Icons.headset,
              color: isPhone ? AppColors.kPrimary : Colors.purple,
              size: 20.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: item.productId ?? "Unknown product",
                  style: appStyle(13, AppColors.kDark, FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                ReusableText(
                  text: "Qty: ${item.quantity} • \$${item.totalSpent}",
                  style: appStyle(11, Colors.grey.shade700, FontWeight.normal),
                ),
              ],
            ),
          ),
          ReusableText(
            text: fmt.format(item.date!),
            style: appStyle(11, Colors.grey.shade600, FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
