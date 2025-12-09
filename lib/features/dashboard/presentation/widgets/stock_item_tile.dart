import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

class StockItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int stock;

  const StockItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: appStyle(15, AppColors.kDark, FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: appStyle(13, Colors.grey.shade700, FontWeight.normal),
              ),
            ],
          ),

          // Right
          Text(
            "Stock: $stock",
            style: appStyle(14, AppColors.kPrimary, FontWeight.w700),
          )
        ],
      ),
    );
  }
}
