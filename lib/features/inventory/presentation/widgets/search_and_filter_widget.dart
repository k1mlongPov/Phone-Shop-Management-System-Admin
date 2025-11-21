import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

typedef OnQueryChanged = void Function(String q);
typedef SetSortField<T> = void Function(T field);
typedef ClearSort = void Function();

class SearchAndFilter<TSortKey> extends StatelessWidget {
  final Map<TSortKey, String> sortOptions;

  /// Allow both nullable and non-nullable Rx values.
  final Rx<TSortKey> selectedSortField;

  final RxString sortOrder;

  final SetSortField<TSortKey> onSetSortField;
  final ClearSort onClearSort;
  final OnQueryChanged onQueryChanged;

  final String hintText;
  final double searchWidthFraction;
  final double sortWidthFraction;

  const SearchAndFilter({
    super.key,
    required this.sortOptions,
    required this.selectedSortField,
    required this.sortOrder,
    required this.onSetSortField,
    required this.onClearSort,
    required this.onQueryChanged,
    this.hintText = 'Search...',
    this.searchWidthFraction = 0.55,
    this.sortWidthFraction = 0.35,
  });

  bool _isNullValue(TSortKey value) {
    // Hack to detect nullable enum or null fallback
    return value == null ||
        value.toString() == 'null' ||
        value.toString().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// SEARCH
          SizedBox(
            width: AppSize.width * searchWidthFraction,
            height: 45.h,
            child: CustomTextField(
              onChanged: onQueryChanged,
              hintText: hintText,
              prefixIcon:
                  Icon(Icons.search, size: 20.r, color: AppColors.kGray),
            ),
          ),

          /// SORT DROPDOWN
          Obx(() {
            final TSortKey selected = selectedSortField.value;
            final bool isDefault = _isNullValue(selected);

            final String label =
                isDefault ? "Sort by" : (sortOptions[selected] ?? "Sort by");

            return GestureDetector(
              onTap: () => _showSortSheet(context),
              child: Container(
                width: AppSize.width * sortWidthFraction,
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border.all(width: .6, color: AppColors.kGray),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: ReusableText(
                        text: label,
                        overflow: TextOverflow.ellipsis,
                        style: appStyle(12, AppColors.kGray, FontWeight.normal),
                      ),
                    ),
                    Row(
                      children: [
                        if (!isDefault)
                          Icon(
                            sortOrder.value == 'asc'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 16.r,
                            color: AppColors.kPrimary,
                          ),
                        SizedBox(width: 6.w),
                        Icon(Icons.keyboard_arrow_down,
                            size: 18.r, color: AppColors.kDark),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: .6.sh,
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),

              ReusableText(
                text: "Sort Options",
                style: appStyle(16, AppColors.kDark, FontWeight.w600),
              ),
              Divider(height: 20.h),

              /// CLEAR OPTION
              Obx(() {
                final bool isClear = _isNullValue(selectedSortField.value);

                return ListTile(
                  title: ReusableText(
                    text: "Clear sorting",
                    style: appStyle(12, AppColors.kDark, FontWeight.normal),
                  ),
                  trailing: isClear
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onClearSort();
                    Navigator.pop(context);
                  },
                );
              }),

              const Divider(),

              /// SORT OPTIONS
              Expanded(
                child: Obx(() {
                  final current = selectedSortField.value;
                  final currentDir = sortOrder.value;

                  return ListView(
                    children: sortOptions.entries.map((entry) {
                      final key = entry.key;
                      final bool isSelected = key == current;

                      return ListTile(
                        title: ReusableText(
                          text: entry.value,
                          style: appStyle(
                            12,
                            AppColors.kDark,
                            FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    currentDir == 'asc'
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 16.r,
                                    color: AppColors.kPrimary,
                                  ),
                                  SizedBox(width: 6.w),
                                  const Icon(Icons.check, color: Colors.blue),
                                ],
                              )
                            : null,
                        onTap: () {
                          onSetSortField(key);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
