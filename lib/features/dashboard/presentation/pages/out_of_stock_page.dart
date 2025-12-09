import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/stock_item_tile.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class OutOfStockPage extends StatelessWidget {
  const OutOfStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Out of Stock Items",
          style: appStyle(16, AppColors.kWhite, FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: AppColors.kWhite, size: 22.r),
        ),
      ),
      body: Obx(
        () {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final phones = c.outStockPhones;
          final accs = c.outStockAccessories;

          if (phones.isEmpty && accs.isEmpty) {
            return Center(
              child: ReusableText(
                text: "No out-of-stock items.",
                style: appStyle(16, AppColors.kDark, FontWeight.bold),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(14),
            children: [
              if (phones.isNotEmpty)
                const Text("📱 Phones",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...phones.map(
                (p) => StockItemTile(
                  title: "${p.brand} ${p.model}",
                  subtitle: "0 stock",
                  stock: 0,
                ),
              ),
              if (accs.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  "🎧 Accessories",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
              ...accs.map(
                (a) => StockItemTile(
                  title: a.name,
                  subtitle: "0 stock",
                  stock: 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
