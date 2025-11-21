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

/// Build accessory info card (images carousel, details, compatibility, history, actions)
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
          Column(
            children: [
              // Reuse your image carousel builder (rename or create a generic one if needed)
              ImageCarousel(
                images: a.images,
                activeIndex: activeImageIndex,
                height: 220,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.h),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    final isActive = i == activeImageIndex.value;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: isActive ? 16.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.kPrimary : Colors.grey,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    );
                  }),
                );
              }),
            ],
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
          child: Padding(
            padding: EdgeInsets.all(12.r),
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
        SizedBox(height: 12.h),
        if ((a.attributes ?? {}).isNotEmpty)
          ReusableText(
            text: 'Attributes',
            style: appStyle(18, AppColors.kDark, FontWeight.w600),
          ),
        SizedBox(height: 12.h),
        if ((a.attributes ?? {}).isNotEmpty)
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
            child: Padding(
              padding: EdgeInsets.all(12.r),
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

        // Restock history / sale history summary (optional)
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
          SizedBox(height: 12.h),
        ],

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit, color: AppColors.kWhite, size: 20.r),
                label: ReusableText(
                  text: 'Edit',
                  style: appStyle(12, AppColors.kWhite, FontWeight.w400),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: () => _onEditAccessory(a),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete, color: AppColors.kRed),
                label: ReusableText(
                  text: 'Delete',
                  style: appStyle(12, AppColors.kRed, FontWeight.w400),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.kRed),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: () => _onDeleteAccessory(a, accessoryCtrl),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
      ],
    ),
  );
}

/// Convert attributes map into simple widgets
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

/// Navigation to edit page
void _onEditAccessory(Accessory a) {
  Get.toNamed('/accessories/edit', arguments: a);
}

/// Delete accessory confirmation and action
Future<void> _onDeleteAccessory(
    Accessory a, AccessoryController accessoryCtrl) async {
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Delete accessory'),
      content: Text('Delete "${a.name}"?'),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete')),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await accessoryCtrl.deleteAccessory(a.id ?? '');
    Get.back(); // pop detail
    Get.snackbar('Deleted', 'Accessory deleted');
  } catch (e) {
    Get.snackbar('Error', 'Delete failed: $e');
  }
}
