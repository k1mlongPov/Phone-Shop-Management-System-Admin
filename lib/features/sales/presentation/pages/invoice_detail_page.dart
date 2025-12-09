import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/features/sales/domain/models/invoice_model.dart';

class InvoiceDetailPage extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(invoice.invoiceNo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${invoice.customerName}"),
            Text("Phone: ${invoice.customerPhone}"),
            const SizedBox(height: 10),
            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
            ...invoice.items.map((i) => ListTile(
                  title: Text(i.productName),
                  subtitle: Text("${i.quantity} × \$${i.unitPrice}"),
                  trailing: Text("\$${i.totalPrice}"),
                )),
            const Divider(),
            Text("Subtotal: \$${invoice.subtotal}"),
            Text("Discount: \$${invoice.discount}"),
            Text("Tax: \$${invoice.tax}"),
            const SizedBox(height: 6),
            Text(
              "Total: \$${invoice.total}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
