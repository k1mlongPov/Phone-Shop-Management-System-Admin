import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/sales/logic/sale_controller.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';

class SaleCheckoutButton extends StatefulWidget {
  final SaleController controller;
  final Future<void> Function(SaleController controller) onPay;

  const SaleCheckoutButton({
    super.key,
    required this.controller,
    required this.onPay,
  });

  @override
  State<SaleCheckoutButton> createState() => _SaleCheckoutButtonState();
}

class _SaleCheckoutButtonState extends State<SaleCheckoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final noCustomer = widget.controller.selectedCustomer.value == null;
        final noTotal = widget.controller.total.value == 0;
        final isDisabled = noCustomer || noTotal;

        return GestureDetector(
          onTap: () {
            if (isDisabled) {
              _shakeCtrl.forward(from: 0);
            }
          },
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: FloatingActionButton.extended(
              heroTag: 'orders',
              backgroundColor: isDisabled ? Colors.grey : AppColors.kPrimary,
              onPressed: isDisabled
                  ? null
                  : () async {
                      await widget.onPay(widget.controller);
                    },
              label: Row(
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  SizedBox(width: 6.w),
                  Text(
                    "Checkout",
                    style: appStyle(14, Colors.white, FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
