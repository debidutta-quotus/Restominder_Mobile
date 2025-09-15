// store_entity.dart (updated)
class StoreEntity {
  final String id;
  final int? posId;
  final List<int>? deliveryPartnerID;
  final String storeName;
  final String brandName;
  final String businessType;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String neighbourhood;
  final String cuisineType;
  final int? numberOfLocation;
  final String? description;
  final String? websiteUrl;
  final bool? available;
  final String? status;
  final String openTime;
  final String closeTime;
  final List<String> operatingDays;
  final DateTime? createdAt;
  final DateTime? updateAt;
  final AddressEntity address;
  final List<BankDetailsEntity> bankDetails;

  StoreEntity({
    required this.id,
    this.posId,
    this.deliveryPartnerID,
    required this.storeName,
    required this.brandName,
    required this.businessType,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.neighbourhood,
    required this.cuisineType,
    this.numberOfLocation,
    this.description,
    this.websiteUrl,
    this.available,
    this.status,
    required this.openTime,
    required this.closeTime,
    required this.operatingDays,
    this.createdAt,
    this.updateAt,
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
  final String? latitude;
  final String? longitude;
  final String? storeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressEntity({
    required this.id,
    required this.streetAddress,
    required this.floor,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  String get fullAddress => 
      '$streetAddress, Floor $floor, $city, $region, $country - $postalCode';
}

class BankDetailsEntity {
  final String id;
  final String storeId;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String ifscCode;
  final String iban;
  final String swiftCode;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updateAt;

  BankDetailsEntity({
    required this.id,
    required this.storeId,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.ifscCode,
    required this.iban,
    required this.swiftCode,
    required this.isPrimary,
    this.createdAt,
    this.updateAt,
  });
}