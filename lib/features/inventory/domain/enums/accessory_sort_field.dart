enum AccessorySortField {
  name,
  price,
  stock,
  createdAt,
}

extension AccessorySortFieldX on AccessorySortField {
  /// Backend key depends on the sort order ('asc' / 'desc')
  String backendKey(String order) {
    switch (this) {
      case AccessorySortField.price:
        return order == 'asc' ? 'price_asc' : 'price_desc';
      case AccessorySortField.stock:
        return order == 'asc' ? 'stock_asc' : 'stock_desc';
      case AccessorySortField.createdAt:
        // backend expects `oldest` for ASC, `latest` for DESC
        return order == 'asc' ? 'oldest' : 'latest';

      case AccessorySortField.name:
        return 'name';
    }
  }

  /// Human-readable label (shown in sort sheet)
  String label(String order) {
    switch (this) {
      case AccessorySortField.price:
        return order == 'asc' ? 'Price ↑' : 'Price ↓';
      case AccessorySortField.stock:
        return order == 'asc' ? 'Stock ↑' : 'Stock ↓';
      case AccessorySortField.createdAt:
        return order == 'asc' ? 'Oldest' : 'Newest';

      case AccessorySortField.name:
        return 'Name';
    }
  }
}
