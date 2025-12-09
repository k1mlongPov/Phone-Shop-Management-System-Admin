enum PhoneCondition {
  usedLocal, // used from customer
  newCompany, // new from Oppo/Vivo official company
  newImport, // new imported from US/Japan, etc.
}

extension PhoneConditionX on PhoneCondition {
  String get backendValue {
    switch (this) {
      case PhoneCondition.usedLocal:
        return 'used_local';
      case PhoneCondition.newCompany:
        return 'new_company';
      case PhoneCondition.newImport:
        return 'new_import';
    }
  }

  static PhoneCondition fromBackend(String? value) {
    switch (value) {
      case 'used_local':
        return PhoneCondition.usedLocal;
      case 'new_import':
        return PhoneCondition.newImport;
      case 'new_company':
      default:
        return PhoneCondition.newCompany;
    }
  }

  String get label {
    switch (this) {
      case PhoneCondition.usedLocal:
        return 'Used';
      case PhoneCondition.newCompany:
        return 'New';
      case PhoneCondition.newImport:
        return 'Imported';
    }
  }
}
