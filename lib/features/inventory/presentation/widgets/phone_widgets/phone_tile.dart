import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/phone_detail_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_tile.dart';

class PhoneTile extends StatelessWidget {
  final Phone phone;
  const PhoneTile({required this.phone, super.key});

  @override
  Widget build(BuildContext context) {
    final img = (phone.images != null && phone.images!.isNotEmpty)
        ? phone.images!.first
        : null;
    return ProductTile(
      image: '$img',
      title: '${phone.brand} ${phone.model}',
      subtitle: 'Price: ${phone.pricing.sellingPrice} • Stock: ${phone.stock}',
      onTap: () => Get.to(() => const PhoneDetailPage(), arguments: phone.id),
    );
  }
}
