class RestockEntry {
  final String productId;
  final String productName;
  final String modelType;
  final String? variantLabel;
  final int quantity;
  final String? note;
  final String? supplierId;
  final String supplierName;
  final DateTime date;

  RestockEntry({
    required this.productId,
    required this.productName,
    required this.modelType,
    this.variantLabel,
    required this.quantity,
    this.note,
    this.supplierId,
    required this.supplierName,
    required this.date,
  });

  factory RestockEntry.fromJson(Map<String, dynamic> json) {
    final supplier = json["supplier"];

    String? supplierId;
    String supplierName = "Unknown";

    if (supplier is Map) {
      supplierId = supplier["id"]?.toString() ?? supplier["_id"]?.toString();
      supplierName = supplier["name"]?.toString() ?? "Unknown";
    } else if (supplier is String) {
      supplierId = supplier;
      supplierName = "Unknown";
    }

    return RestockEntry(
      productId: json["productId"].toString(),
      productName: (json["productName"] ?? "Unknown product").toString(),
      modelType: (json["modelType"] ?? "Unknown").toString(),
      variantLabel: json["variantLabel"]?.toString(),
      quantity: int.tryParse(json["quantity"].toString()) ?? 0,
      note: json["note"]?.toString(),
      supplierId: supplierId,
      supplierName: supplierName,
      date: DateTime.tryParse(json["date"].toString()) ?? DateTime.now(),
    );
  }
}
