enum PhoneSortField {
  none,
  price,
  brand,
  model,
  stock,
  createdAt,
}

extension PhoneSortFieldName on PhoneSortField {
  String get apiName {
    switch (this) {
      case PhoneSortField.price:
        return 'price';
      case PhoneSortField.brand:
        return 'brand';
      case PhoneSortField.model:
        return 'model';
      case PhoneSortField.stock:
        return 'stock';
      case PhoneSortField.createdAt:
        return 'created_at';
      case PhoneSortField.none:
      default:
        return '';
    }
  }
}
