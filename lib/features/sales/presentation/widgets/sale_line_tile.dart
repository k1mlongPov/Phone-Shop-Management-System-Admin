import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/product_picker_bottom_sheet.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class SaleLineTile extends StatelessWidget {
  final int index;
  final SaleController saleCtrl;
  final PhoneController phoneCtrl;
  final AccessoryController accCtrl;
  final GlobalKey<AnimatedListState> listKey;

  const SaleLineTile({
    super.key,
    required this.index,
    required this.saleCtrl,
    required this.phoneCtrl,
    required this.accCtrl,
    required this.listKey,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (index >= saleCtrl.items.length) {
          return const SizedBox();
        }

        final line = saleCtrl.items[index];

        return Container(
          margin: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.kWhite,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(9, 30, 66, 0.25),
                blurRadius: 1,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(9, 30, 66, 0.13),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () async {
                    final result = await Get.bottomSheet(
                      ProductPickerBottomSheet(
                        phones: phoneCtrl.phones,
                        accessories: accCtrl.accessories,
                        onSelect: ({
                          required productId,
                          required name,
                          required modelType,
                          variantId,
                          variantLabel,
                          required price,
                          required stock,
                        }) {
                          saleCtrl.updateProductForLine(
                            index,
                            productId: productId,
                            name: name,
                            modelType: modelType,
                            variantId: variantId,
                            variantLabel: variantLabel,
                            price: price,
                            stock: stock,
                          );
                        },
                      ),
                      isScrollControlled: true,
                    );

                    if (result != null) {
                      saleCtrl.updateProductForLine(
                        index,
                        productId: result["productId"],
                        name: result["name"],
                        modelType: result["modelType"],
                        variantId: result["variantId"],
                        variantLabel: result["variantLabel"],
                        price: result["price"],
                        stock: result["stock"],
                      );
                    }
                  },
                  child: Row(
                    children: [
                      line.productId == null
                          ? const Icon(
                              Icons.inventory,
                              color: AppColors.kPrimary,
                            )
                          : line.variantId == null
                              ? const Icon(
                                  Icons.headphones,
                                  color: AppColors.kPrimary,
                                )
                              : const Icon(
                                  Icons.phone_android,
                                  color: AppColors.kPrimary,
                                ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: line.productName ?? "Select Product",
                              overflow: TextOverflow.ellipsis,
                              style: appStyle(
                                13,
                                line.productName == null
                                    ? Colors.grey
                                    : AppColors.kDark,
                                FontWeight.w600,
                              ),
                            ),
                            line.variantId != null
                                ? ReusableText(
                                    text: line.variantLabel ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: appStyle(
                                      11,
                                      Colors.grey,
                                      FontWeight.w400,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      ReusableText(
                        text: line.productId != null
                            ? "Available stock: ${line.availableStock}"
                            : "",
                        style: appStyle(
                          11,
                          Colors.grey,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                const Divider(),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          border: Border.all(width: .6, color: AppColors.kGray),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => saleCtrl.decreaseQty(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey.shade200,
                                ),
                                child: const Icon(Icons.remove, size: 18),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                controller: line.qtyController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: appStyle(
                                  12,
                                  AppColors.kDark,
                                  FontWeight.normal,
                                ),
                                cursorColor: AppColors.kPrimary,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  final num = int.tryParse(val) ?? 1;
                                  saleCtrl.setQtyFromInput(index, num);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => saleCtrl.increaseQty(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: AppColors.kPrimary.withOpacity(.8),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 18.r,
                                  color: AppColors.kWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextField(
                        controller: line.priceController,
                        label: "Unit Price",
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final price = double.tryParse(val) ?? 0;
                          line.unitPrice = price;
                          saleCtrl.calculateTotals();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: "Line total:",
                      style: appStyle(12, Colors.grey, FontWeight.w600),
                    ),
                    ReusableText(
                      text: "\$${line.lineTotal.toStringAsFixed(2)}",
                      style: appStyle(14, AppColors.kPrimary, FontWeight.bold),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      listKey.currentState?.removeItem(
                        index,
                        (context, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: SaleLineTile(
                              index: index,
                              saleCtrl: saleCtrl,
                              phoneCtrl: phoneCtrl,
                              accCtrl: accCtrl,
                              listKey: listKey,
                            ),
                          );
                        },
                        duration: const Duration(milliseconds: 250),
                      );

                      // remove from controller after animation
                      Future.delayed(const Duration(milliseconds: 250), () {
                        saleCtrl.removeLine(index);
                      });
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
