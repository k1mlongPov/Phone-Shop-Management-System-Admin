import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class RecentSalesWidget extends GetView<DashboardController> {
  const RecentSalesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: 'Recent Sales',
                style: appStyle(16, AppColors.kDark, FontWeight.bold),
              ),
              ...controller.recentSales.map(
                (s) => Material(
                  color: AppColors.kWhite,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s['id']),
                    trailing: Text('\$${s['amount']}'),
                    subtitle: Text('${s['customer']} • ${s['date']}'),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
