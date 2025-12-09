import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/accessory_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/phone_condition.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/phone_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/search_and_filter_widget.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';

class ProductPickerBottomSheet extends StatelessWidget {
  final List<Phone> phones;
  final List<Accessory> accessories;

  /// Callback after picking a product
  final Function({
    required String productId,
    required String name,
    required String modelType,
    String? variantId,
    String? variantLabel,
    required double price,
    required int stock,
  }) onSelect;

  const ProductPickerBottomSheet({
    super.key,
    required this.phones,
    required this.accessories,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.kGray.withOpacity(.7),
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: ReusableText(
                text: "Select Product",
                style: appStyle(16, AppColors.kDark, FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: AppColors.kPrimary,
                      labelColor: AppColors.kPrimary,
                      unselectedLabelColor: Colors.grey,
                      labelStyle:
                          appStyle(14, AppColors.kPrimary, FontWeight.w500),
                      tabs: const [
                        Tab(text: "Phones"),
                        Tab(text: "Accessories"),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _phoneList(),
                          _accessoryList(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _phoneList() {
    if (phones.isEmpty) {
      return Center(
        child: ReusableText(
          text: "No phones found",
          style: appStyle(12, Colors.grey, FontWeight.normal),
        ),
      );
    }

    return Obx(
      () {
        final Map<PhoneSortField, String> sortOptions = {
          PhoneSortField.createdAt: 'Newest',
          PhoneSortField.price: 'Price',
          PhoneSortField.brand: 'Brand',
          PhoneSortField.model: 'Model',
          PhoneSortField.stock: 'Stock',
        };

        final phoneCtrl = Get.find<PhoneController>();
        return Column(
          children: [
            SearchAndFilter<PhoneSortField>(
              sortOptions: sortOptions,
              selectedSortField: phoneCtrl.sortField,
              sortOrder: phoneCtrl.sortOrder,
              onSetSortField: (f) => phoneCtrl.setSortField(f),
              onClearSort: () => phoneCtrl.clearSort(),
              onQueryChanged: (s) => phoneCtrl.setQuery(s),
              hintText: 'Search phones...',
            ),
            SizedBox(
              height: 12.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: phones.length,
                itemBuilder: (_, i) => _buildPhoneItem(phones[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhoneItem(Phone phone) {
    if (phone.variants!.length == 1) {
      final v = phone.variants!.first;

      final label = "${v.storage}GB • ${v.color} • ${v.condition.label}";

      return GestureDetector(
        onTap: () {
          onSelect(
            productId: phone.id!,
            name: "${phone.brand} ${phone.model}",
            modelType: "Phone",
            variantId: v.id,
            variantLabel: label,
            price: v.pricing!.sellingPrice,
            stock: v.stock!,
          );
          Get.back();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.w),
          decoration: _box(),
          child: Row(
            children: [
              const Icon(Icons.phone_android, color: AppColors.kPrimary),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "${phone.brand} ${phone.model}",
                      style: appStyle(14, AppColors.kDark, FontWeight.w600),
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: label,
                      style: appStyle(
                        12,
                        AppColors.kDark.withOpacity(.8),
                        FontWeight.normal,
                      ),
                    ),
                    ReusableText(
                      text: "Stock: ${v.stock}",
                      style: appStyle(
                        12,
                        AppColors.kGray,
                        FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              ReusableText(
                text: "\$${v.pricing!.sellingPrice}",
                style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h, top: 10.h),
      decoration: _box(),
      child: ExpansionTile(
        title: ReusableText(
          text: "${phone.brand} ${phone.model}",
          style: appStyle(14, AppColors.kDark, FontWeight.w600),
        ),
        leading: const Icon(
          Icons.phone_android_outlined,
          color: AppColors.kPrimary,
        ),
        children: phone.variants!.map((v) {
          final label = "${v.storage}GB • ${v.color} • ${v.condition.label}";

          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            child: ListTile(
              leading: const Icon(Icons.layers, color: AppColors.kPrimary),
              title: ReusableText(
                text: label,
                style: appStyle(13, AppColors.kDark, FontWeight.w600),
              ),
              subtitle: ReusableText(
                text: "Stock: ${v.stock}",
                style: appStyle(12, AppColors.kGray, FontWeight.w600),
              ),
              trailing: ReusableText(
                text: "\$${v.pricing!.sellingPrice}",
                style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
              ),
              onTap: () {
                onSelect(
                  productId: phone.id!,
                  name: "${phone.brand} ${phone.model}",
                  modelType: "Phone",
                  variantId: v.id,
                  variantLabel: label,
                  price: v.pricing!.sellingPrice,
                  stock: v.stock!,
                );
                Get.back();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _accessoryList() {
    if (accessories.isEmpty) {
      return Center(
        child: ReusableText(
          text: "No accessories found",
          style: appStyle(12, Colors.grey, FontWeight.normal),
        ),
      );
    }

    return Obx(
      () {
        final AccessoryController accessoryCtrl =
            Get.find<AccessoryController>();
        final Map<AccessorySortField, String> accessorySortOptions = {
          AccessorySortField.createdAt: 'Newest',
          AccessorySortField.name: 'Name',
          AccessorySortField.price: 'Price',
          AccessorySortField.stock: 'Stock',
        };
        return Column(
          children: [
            SearchAndFilter<AccessorySortField>(
              selectedSortField: accessoryCtrl.sortField,
              sortOrder: accessoryCtrl.sortOrder,
              onSetSortField: (field) => accessoryCtrl.setSortField(field),
              onClearSort: () => accessoryCtrl.clearSort(),
              onQueryChanged: (s) => accessoryCtrl.setQuery(s),
              hintText: 'Search accessories...',
              sortOptions: accessorySortOptions,
            ),
            SizedBox(
              height: 12.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: accessories.length,
                itemBuilder: (_, i) => _buildAccessoryItem(accessories[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccessoryItem(Accessory a) {
    return GestureDetector(
      onTap: () {
        onSelect(
          productId: a.id!,
          name: a.name,
          modelType: "Accessory",
          variantId: null,
          variantLabel: null,
          price: a.pricing.sellingPrice,
          stock: a.stock,
        );
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: _box(),
        child: ListTile(
          leading: const Icon(
            Icons.headphones,
            color: AppColors.kPrimary,
          ),
          title: ReusableText(
            text: a.name,
            style: appStyle(13, AppColors.kDark, FontWeight.w600),
          ),
          subtitle: ReusableText(
            text: "Stock: ${a.stock}",
            style: appStyle(12, AppColors.kGray, FontWeight.w400),
          ),
          trailing: ReusableText(
            text: "\$${a.pricing.sellingPrice}",
            style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
          ),
        ),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: AppColors.kWhite,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    );
  }
}
