import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/image_carousel.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/row_text_widget.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget buildPhoneInfoCard(
  BuildContext context,
  Phone p,
  PageController pageController,
  RxInt activeImageIndex,
  PhoneController phoneCtrl,
  CategoryController catCtrl,
) {
  final images = p.images ?? <String>[];

  return SingleChildScrollView(
    padding: EdgeInsets.all(12.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isEmpty)
          Container(
            height: 260.h,
            color: Colors.grey.shade100,
            child: Center(
                child:
                    Icon(Icons.phone_android, size: 70.r, color: Colors.grey)),
          )
        else
          Column(
            children: [
              ImageCarousel(
                images: p.images,
                pageController: pageController,
                activeIndex: activeImageIndex,
                onTap: (idx, url) {},
                height: 260, // pixel value interpreted by ScreenUtil (height.h)
              ),
              SizedBox(height: 8.h),
            ],
          ),

        SizedBox(height: 18.h),

        // Info card
        ReusableText(
          text: 'Details',
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
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              children: [
                rowText('Brand', p.brand),
                rowText('Model', p.model),
                rowText(
                    'Selling', '${p.pricing.sellingPrice} ${p.currency ?? ''}'),
                rowText('Purchase',
                    '${p.pricing.purchasePrice} ${p.currency ?? ''}'),
                rowText('Stock', p.totalStock.toString()),
                rowText('SKU', p.sku ?? '-'),
                Obx(
                  () {
                    final cid = catCtrl.getCategoryNameIncludingSub(p.category);
                    final name = cid == null
                        ? '-'
                        : (catCtrl.getCategoryNameIncludingSub(cid) ?? cid);
                    return rowText('Category', name);
                  },
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),
        ReusableText(
          text: 'Specs',
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
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: p.specs == null
                ? Text('No specs', style: TextStyle(fontSize: 13.sp))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (p.specs!.chipset != null)
                        rowText('Chipset', p.specs!.chipset!),
                      if (p.specs!.ram != null)
                        rowText('RAM', '${p.specs!.ram} GB'),
                      if (p.specs!.storage != null)
                        rowText('Storage', '${p.specs!.storage} GB'),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 12.h),
        ReusableText(
          text: 'Variants',
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
            children: (p.variants ?? []).map((v) {
              return ListTile(
                title: ReusableText(
                  text:
                      '${v.storage ?? ''} GB • Color: ${v.color ?? ''}'.trim(),
                  style: appStyle(14, AppColors.kDark, FontWeight.w500),
                ),
                subtitle: ReusableText(
                  text:
                      'Stock: ${v.stock ?? 0} • Price: ${v.pricing?.sellingPrice ?? '-'}',
                  style: appStyle(12, AppColors.kPrimary, FontWeight.w400),
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed('/phones/variant/edit',
                          arguments: {'phoneId': p.id, 'variant': v});
                    }),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.kPrimary),
                ),
                icon: Icon(
                  Icons.edit,
                  color: AppColors.kWhite,
                  size: 22.r,
                ),
                label: ReusableText(
                  text: 'Edit',
                  style: appStyle(12, AppColors.kWhite, FontWeight.w400),
                ),
                onPressed: () => _onEdit(p),
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
                onPressed: () => _onDelete(p, phoneCtrl),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.kRed),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    ),
  );
}

void _onEdit(Phone p) {
  Get.toNamed('/phones/edit', arguments: p);
}

Future<void> _onDelete(Phone p, PhoneController phoneCtrl) async {
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Delete phone'),
      content: Text('Delete "${p.brand} ${p.model}"?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await phoneCtrl.deletePhone(p.id ?? '');
    Get.back(); // pop detail
    Get.snackbar('Deleted', 'Phone deleted');
  } catch (e) {
    Get.snackbar('Error', 'Delete failed: $e');
  }
}
