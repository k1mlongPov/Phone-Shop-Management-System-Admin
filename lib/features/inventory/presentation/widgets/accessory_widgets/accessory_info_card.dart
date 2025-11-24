import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/image_carousel.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/row_text_widget.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget buildAccessoryInfoCard(
  BuildContext context,
  Accessory a,
  PageController pageController,
  RxInt activeImageIndex,
  AccessoryController accessoryCtrl,
  CategoryController catCtrl,
) {
  final images = a.images ?? <String>[];

  return SingleChildScrollView(
    padding: EdgeInsets.all(16.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images carousel / placeholder
        if (images.isEmpty)
          Container(
            height: 260.h,
            color: Colors.grey.shade100,
            child: Center(
              child: Icon(Icons.headphones, size: 70.r, color: Colors.grey),
            ),
          )
        else
          ImageCarousel(
            images: a.images,
            activeIndex: activeImageIndex,
            height: 220,
            fit: BoxFit.cover,
          ),

        SizedBox(height: 18.h),

        // Details header
        ReusableText(
          text: 'Details',
          style: appStyle(18, AppColors.kDark, FontWeight.bold),
        ),
        SizedBox(height: 8.h),

        // Info card
        Container(
          width: AppSize.width,
          color: AppColors.kWhite,
          child: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Column(
              children: [
                rowText('Name', a.name),
                rowText('Type', a.type),
                rowText('Brand', a.brand ?? '-'),
                rowText('Selling', '${a.pricing.sellingPrice} ${a.currency}'),
                rowText('Purchase', '${a.pricing.purchasePrice} ${a.currency}'),
                rowText('Stock', (a.stock).toString()),
                rowText('SKU', a.sku ?? '-'),
                Obx(() {
                  final cid = catCtrl.getCategoryNameIncludingSub(a.categoryId);
                  final name = cid == null
                      ? '-'
                      : (catCtrl.getCategoryNameIncludingSub(cid) ?? cid);
                  return rowText('Category', name);
                }),
                if ((a.compatibility ?? []).isNotEmpty)
                  rowText('Compatibility', (a.compatibility ?? []).join(', ')),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        if ((a.attributes ?? {}).isNotEmpty)
          ReusableText(
            text: 'Attributes',
            style: appStyle(18, AppColors.kDark, FontWeight.w600),
          ),
        if ((a.attributes ?? {}).isNotEmpty)
          Container(
            width: AppSize.width,
            color: AppColors.kWhite,
            child: Padding(
              padding: EdgeInsets.only(left: 12..w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.h),
                  ..._buildAttributesList(a.attributes!),
                ],
              ),
            ),
          ),

        SizedBox(height: 16.h),

        if ((a.restockHistory ?? []).isNotEmpty) ...[
          ReusableText(
            text: 'Restock History',
            style: appStyle(16, AppColors.kDark, FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Container(
            width: AppSize.width,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.09),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: (a.restockHistory ?? []).map((r) {
                final dateStr =
                    r.date?.toLocal().toString().split('.')[0] ?? '-';
                return ListTile(
                  title: Text(
                      'Qty: ${r.quantity ?? '-'} • Supplier: ${r.supplier ?? '-'}'),
                  subtitle: Text(dateStr),
                );
              }).toList(),
            ),
          ),
        ],
        SizedBox(height: 20.h),
      ],
    ),
  );
}

List<Widget> _buildAttributesList(Map<String, dynamic> attr) {
  final widgets = <Widget>[];
  attr.forEach(
    (k, v) {
      widgets.add(
        rowText(k, v?.toString() ?? '-'),
      );
    },
  );
  return widgets;
}
