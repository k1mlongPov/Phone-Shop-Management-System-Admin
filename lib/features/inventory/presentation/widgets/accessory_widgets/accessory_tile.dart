import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/pages/accessory_detail_page.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/product_tile.dart';

class AccessoryTile extends StatelessWidget {
  final Accessory accessory;
  const AccessoryTile({required this.accessory, super.key});

  @override
  Widget build(BuildContext context) {
    final img = (accessory.images != null && accessory.images!.isNotEmpty)
        ? accessory.images!.first
        : null;
    return ProductTile(
      image: '$img',
      title: accessory.name,
      subtitle:
          'Price: ${accessory.pricing.sellingPrice} • Stock: ${accessory.stock}',
      onTap: () =>
          Get.to(() => const AccessoryDetailPage(), arguments: accessory.id),
    );
  }
}
