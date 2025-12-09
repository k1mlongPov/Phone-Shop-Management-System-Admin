class TopSellingItem {
  final String productId;
  final String name;
  final String modelType;
  final int quantity;

  TopSellingItem({
    required this.productId,
    required this.name,
    required this.modelType,
    required this.quantity,
  });

  factory TopSellingItem.fromJson(Map<String, dynamic> json) {
    return TopSellingItem(
      productId: json["productId"],
      name: json["name"],
      modelType: json["modelType"],
      quantity: json["quantity"],
    );
  }
}
