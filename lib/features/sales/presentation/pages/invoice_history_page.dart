import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/sales/logic/invoice_history_controller.dart';
import 'package:phone_management_system_admin/features/sales/presentation/pages/invoice_detail_page.dart';

class InvoiceHistoryPage extends StatelessWidget {
  final c = Get.find<InvoiceHistoryController>();

  InvoiceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice History"),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.invoices.isEmpty) {
          return const Center(child: Text("No invoices found"));
        }

        return ListView.separated(
          itemCount: c.invoices.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final inv = c.invoices[i];

            return ListTile(
              title: Text(inv.invoiceNo),
              subtitle: Text("${inv.customerName} • \$${inv.total}"),
              trailing: Text(
                "${inv.createdAt?.toLocal()}".split(".")[0],
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Get.to(() => InvoiceDetailPage(invoice: inv));
              },
            );
          },
        );
      }),
    );
  }
}
