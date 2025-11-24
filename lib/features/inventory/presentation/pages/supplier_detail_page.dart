import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SupplierModel supplier = Get.arguments as SupplierModel;

    final supplied = supplier.suppliedProducts ?? [];
    final totalProducts = supplied.length;

    // last restock from suppliedProducts
    String lastRestock = 'N/A';
    if (supplied.isNotEmpty) {
      DateTime? latest;
      for (final sp in supplied) {
        if (sp.lastRestockDate == null || sp.lastRestockDate!.isEmpty) continue;
        final dt = DateTime.tryParse(sp.lastRestockDate!);
        if (dt != null) {
          if (latest == null || dt.isAfter(latest)) latest = dt;
        }
      }
      if (latest != null) {
        lastRestock = DateFormat('dd MMM yyyy').format(latest);
      }
    }

    final createdAt = DateTime.tryParse(supplier.createdAt ?? '');
    final updatedAt = DateTime.tryParse(supplier.updatedAt ?? '');

    final createdStr =
        createdAt != null ? DateFormat('dd MMM yyyy').format(createdAt) : 'N/A';
    final updatedStr =
        updatedAt != null ? DateFormat('dd MMM yyyy').format(updatedAt) : 'N/A';

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            size: 22.r,
            color: AppColors.kWhite,
          ),
        ),
        title: Text(
          supplier.name ?? 'Supplier detail',
          style: appStyle(16, AppColors.kWhite, FontWeight.w600),
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(supplier),
            SizedBox(height: 12.h),
            _buildSummaryRow(
              totalProducts: totalProducts,
              lastRestock: lastRestock,
              createdStr: createdStr,
              updatedStr: updatedStr,
            ),
            SizedBox(height: 12.h),
            _buildContactCard(supplier),
            SizedBox(height: 12.h),
            _buildAddressNotesCard(supplier),
            SizedBox(height: 16.h),
            _buildSuppliedProductsSection(supplier),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // HEADER CARD
  // -------------------------------------------------------
  Widget _buildHeaderCard(SupplierModel s) {
    return Container(
      width: AppSize.width,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(60, 64, 67, 0.3),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(60, 64, 67, 0.15),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.store,
              color: AppColors.kPrimary,
              size: 26.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: s.name ?? '-',
                  style: appStyle(16, AppColors.kWhite, FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  s.contactName != null && s.contactName!.isNotEmpty
                      ? 'Contact: ${s.contactName}'
                      : 'No contact person set',
                  style: appStyle(
                    12,
                    AppColors.kWhite.withOpacity(.85),
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: s.active ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              s.active ? 'Active' : 'Inactive',
              style: appStyle(11, Colors.white, FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // SUMMARY ROW
  // -------------------------------------------------------
  Widget _buildSummaryRow({
    required int totalProducts,
    required String lastRestock,
    required String createdStr,
    required String updatedStr,
  }) {
    return Row(
      children: [
        Expanded(
          child: _summaryTile(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            value: totalProducts.toString(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _summaryTile(
            icon: Icons.calendar_today_outlined,
            label: 'Last restock',
            value: lastRestock,
          ),
        ),
      ],
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 22.r, color: AppColors.kPrimary),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: label,
                  style: appStyle(11, Colors.grey.shade600, FontWeight.w500),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(13, AppColors.kDark, FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // CONTACT CARD
  // -------------------------------------------------------
  Widget _buildContactCard(SupplierModel s) {
    return Container(
      width: AppSize.width,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Contact info',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          _infoRow(
            icon: Icons.person_outline,
            label: 'Contact name',
            value: s.contactName?.trim().isNotEmpty == true
                ? s.contactName!
                : 'Not set',
          ),
          SizedBox(height: 6.h),
          _infoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: s.phone?.trim().isNotEmpty == true ? s.phone! : 'Not set',
          ),
          SizedBox(height: 6.h),
          _infoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: s.email?.trim().isNotEmpty == true ? s.email! : 'Not set',
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // ADDRESS + NOTES CARD
  // -------------------------------------------------------
  Widget _buildAddressNotesCard(SupplierModel s) {
    return Container(
      width: AppSize.width,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Details',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          _infoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: s.address?.trim().isNotEmpty == true
                ? s.address!
                : 'No address provided',
          ),
          SizedBox(height: 8.h),
          ReusableText(
            text: 'Notes',
            style: appStyle(12, Colors.grey.shade700, FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            s.notes?.trim().isNotEmpty == true
                ? s.notes!
                : 'No additional notes.',
            style: appStyle(12, AppColors.kDark, FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: AppColors.kPrimary),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: label,
                style: appStyle(11, Colors.grey.shade600, FontWeight.w500),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: appStyle(12, AppColors.kDark, FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // SUPPLIED PRODUCTS SECTION
  // -------------------------------------------------------
  Widget _buildSuppliedProductsSection(SupplierModel s) {
    final supplied = s.suppliedProducts ?? [];

    return Container(
      width: AppSize.width,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Supplied products',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          if (supplied.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                'No products linked yet.',
                style: appStyle(12, Colors.grey, FontWeight.normal),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: supplied.length,
              separatorBuilder: (_, __) => Divider(
                height: 10.h,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (_, i) {
                final sp = supplied[i];
                final type = sp.modelType ?? '-';
                final productId =
                    (sp.productId?.length ?? 0) > 8 && sp.productId != null
                        ? '${sp.productId!.substring(0, 8)}...'
                        : (sp.productId ?? '-');

                String lastRestock = 'N/A';
                if (sp.lastRestockDate != null &&
                    sp.lastRestockDate!.isNotEmpty) {
                  final dt = DateTime.tryParse(sp.lastRestockDate!);
                  if (dt != null) {
                    lastRestock = DateFormat('dd MMM yyyy').format(dt);
                  }
                }

                IconData icon;
                Color iconColor;
                if (type.toLowerCase() == 'phone') {
                  icon = Icons.phone_android;
                  iconColor = AppColors.kPrimary;
                } else if (type.toLowerCase() == 'accessory') {
                  icon = Icons.headset_rounded;
                  iconColor = Colors.purple;
                } else {
                  icon = Icons.inventory_2_outlined;
                  iconColor = Colors.grey;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: iconColor.withOpacity(0.12),
                    child: Icon(icon, color: iconColor, size: 20.r),
                  ),
                  title: Text(
                    type,
                    style: appStyle(13, AppColors.kDark, FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product ID: $productId',
                        style: appStyle(
                            11, Colors.grey.shade700, FontWeight.normal),
                      ),
                      Text(
                        'Last restock: $lastRestock',
                        style: appStyle(
                            11, Colors.grey.shade700, FontWeight.normal),
                      ),
                    ],
                  ),
                  // Later you can add onTap to navigate to Phone/Accessory detail
                  onTap: () {
                    // TODO: Navigate to product detail if you add that
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
