import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/domain/models/restock_entry.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class RestockHistoryTile extends StatelessWidget {
  final RestockEntry entry;

  RestockHistoryTile({super.key, required this.entry});

  final DateFormat _dateFmt = DateFormat("dd MMM yyyy, hh:mm a");

  @override
  Widget build(BuildContext context) {
    final bool isPhone = entry.modelType == "Phone";

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------- Icon ----------
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.kPrimary.withOpacity(0.08),
            child: Icon(
              isPhone ? Icons.phone_android : Icons.headset_rounded,
              color: AppColors.kPrimary,
              size: 22.r,
            ),
          ),
          SizedBox(width: 10.w),

          // ----------- Main Text Area ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                ReusableText(
                  text: entry.productName,
                  style: appStyle(14, AppColors.kDark, FontWeight.w600),
                ),
                SizedBox(height: 4.h),

                // Variant label (phones only)
                if (entry.variantLabel != null &&
                    entry.variantLabel!.trim().isNotEmpty)
                  Text(
                    entry.variantLabel!,
                    style: appStyle(12, Colors.grey.shade700, FontWeight.w500),
                  ),

                SizedBox(height: 4.h),

                // Supplier
                Text(
                  "Supplier: ${entry.supplierName}",
                  style: appStyle(12, Colors.grey.shade700, FontWeight.normal),
                ),

                // Quantity
                Text(
                  "Quantity: +${entry.quantity}",
                  style: appStyle(12, Colors.green.shade700, FontWeight.w600),
                ),

                // Note (optional)
                if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    "Note: ${entry.note}",
                    style:
                        appStyle(11, Colors.grey.shade700, FontWeight.normal),
                  ),
                ],
              ],
            ),
          ),

          // ----------- Date & Type ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Model Type Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isPhone
                      ? AppColors.kPrimary.withOpacity(0.1)
                      : Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  entry.modelType,
                  style: appStyle(
                    11,
                    isPhone ? AppColors.kPrimary : Colors.purple,
                    FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 6.h),

              // Date
              Text(
                _dateFmt.format(entry.date.toLocal()),
                style: appStyle(11, Colors.grey.shade600, FontWeight.normal),
                textAlign: TextAlign.right,
              ),
            ],
          )
        ],
      ),
    );
  }
}
