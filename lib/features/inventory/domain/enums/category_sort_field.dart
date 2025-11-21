enum CategorySortField {
  name,
  createdAt,
}

extension CategorySortFieldX on CategorySortField {
  String get backendKey {
    switch (this) {
      case CategorySortField.createdAt:
        return 'createdAt';
      case CategorySortField.name:
        return 'name';
    }
  }
}
