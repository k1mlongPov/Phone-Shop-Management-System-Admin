import 'package:flutter/material.dart';

import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/widgets/sale_line_tile.dart';

class SaleLineList extends StatelessWidget {
  final SaleController saleCtrl;
  final PhoneController phoneCtrl;
  final AccessoryController accCtrl;
  final GlobalKey<AnimatedListState> listKey;

  const SaleLineList({
    super.key,
    required this.saleCtrl,
    required this.phoneCtrl,
    required this.accCtrl,
    required this.listKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: saleCtrl.items.length,
      itemBuilder: (context, index, animation) {
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
    );
  }
}
