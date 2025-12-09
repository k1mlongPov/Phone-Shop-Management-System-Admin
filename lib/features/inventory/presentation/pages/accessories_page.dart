import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/enums/accessory_sort_field.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/accessory_widgets/accessory_tile.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/category_filter_widget.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_shimmer.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/search_and_filter_widget.dart';

class AccessoryPage extends StatelessWidget {
  AccessoryPage({super.key});

  final AccessoryController accessoryCtrl = Get.find<AccessoryController>();
  final CategoryController catCtrl = Get.find<CategoryController>();
  final SubCategoryController subCtrl = Get.find<SubCategoryController>();

  /// Example sort options for accessories.
  /// If your AccessoryController uses a different sort key scheme, change these.
  final Map<AccessorySortField, String> accessorySortOptions = {
    AccessorySortField.createdAt: 'Newest',
    AccessorySortField.name: 'Name',
    AccessorySortField.price: 'Price',
    AccessorySortField.stock: 'Stock',
  };

  @override
  Widget build(BuildContext context) {
    if (subCtrl.subcategoriesByParent.isEmpty && !subCtrl.isLoading.value) {
      Future.microtask(() => subCtrl.fetchForType('accessory'));
    }

    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
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

          SizedBox(height: 12.h),
          CategoryFilter(
            parentNameToMatch: 'accessory',
            selectedCategoryId: accessoryCtrl.selectedCategoryId,
            onSetCategory: (id) => accessoryCtrl.setCategoryFilter(id),
          ),

          SizedBox(height: 12.h),
          // List section
          Expanded(
            child: Obx(() {
              if (accessoryCtrl.error.value != null &&
                  accessoryCtrl.accessories.isEmpty) {
                return Center(
                    child: Text('Error: ${accessoryCtrl.error.value}'));
              }
              if (accessoryCtrl.isLoading.value &&
                  accessoryCtrl.accessories.isEmpty) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: 8,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, __) => const ProductShimmer(),
                );
              }
              return RefreshIndicator(
                color: AppColors.kPrimary,
                backgroundColor: AppColors.kWhite,
                onRefresh: accessoryCtrl.refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                            (notification.metrics.maxScrollExtent - 200) &&
                        !accessoryCtrl.isLoadingMore.value &&
                        accessoryCtrl.page < accessoryCtrl.pages.value) {
                      accessoryCtrl.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(12.r),
                    itemCount: accessoryCtrl.accessories.length +
                        (accessoryCtrl.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      if (index >= accessoryCtrl.accessories.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final Accessory accessory =
                          accessoryCtrl.accessories[index];
                      return AccessoryTile(accessory: accessory);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
