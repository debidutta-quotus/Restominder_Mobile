class StoreEntity {
  final String id;
  final String storeName;
  final String brandName;
  final String businessType;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String neighbourhood;
  final String cuisineType;
  final String? description;
  final String? websiteUrl;
  final String openTime;
  final String closeTime;
  final List<String> operatingDays;
  final AddressEntity address;
  final List<BankDetailsEntity> bankDetails;

  StoreEntity({
    required this.id,
    required this.storeName,
    required this.brandName,
    required this.businessType,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.neighbourhood,
    required this.cuisineType,
    this.description,
    this.websiteUrl,
    required this.openTime,
    required this.closeTime,
    required this.operatingDays,
    required this.address,
    required this.bankDetails,
  });

  String get fullName => '$firstName $lastName';
  String get operatingHours => '$openTime - $closeTime';
}

class AddressEntity {
  final String id;
  final String streetAddress;
  final int floor;
  final String city;
  final String region;
  final String country;
  final String postalCode;

  AddressEntity({
    required this.id,
    required this.streetAddress,
    required this.floor,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
  });

  String get fullAddress => 
      '$streetAddress, Floor $floor, $city, $region, $country - $postalCode';
}

class BankDetailsEntity {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String ifscCode;
  final String iban;
  final String swiftCode;
  final bool isPrimary;

  BankDetailsEntity({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.ifscCode,
    required this.iban,
    required this.swiftCode,
    required this.isPrimary,
  });
}