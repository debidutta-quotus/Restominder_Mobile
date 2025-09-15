import '../../domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required super.id,
    required super.storeName,
    required super.brandName,
    required super.businessType,
    required super.firstName,
    required super.lastName,
    required super.contactNumber,
    required super.email,
    required super.neighbourhood,
    required super.cuisineType,
    super.description,
    super.websiteUrl,
    required super.openTime,
    required super.closeTime,
    required super.operatingDays,
    required super.address,
    required super.bankDetails,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      storeName: json['storeName'] ?? '',
      brandName: json['brandName'] ?? '',
      businessType: json['businessType'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      neighbourhood: json['neighbourhood'] ?? '',
      cuisineType: json['cuisineType'] ?? '',
      description: json['description'],
      websiteUrl: json['websiteUrl'],
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      operatingDays: List<String>.from(json['operatingDays'] ?? []),
      address: AddressModel.fromJson(json['address'] ?? {}),
      bankDetails: (json['bankDetails'] as List<dynamic>?)
          ?.map((bank) => BankDetailsModel.fromJson(bank))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'brandName': brandName,
      'businessType': businessType,
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'email': email,
      'neighbourhood': neighbourhood,
      'cuisineType': cuisineType,
      'description': description,
      'websiteUrl': websiteUrl,
      'openTime': openTime,
      'closeTime': closeTime,
      'operatingDays': operatingDays,
      'address': (address as AddressModel).toJson(),
      'bankDetails': bankDetails.map((bank) => (bank as BankDetailsModel).toJson()).toList(),
    };
  }
}

class AddressModel extends AddressEntity {
  AddressModel({
    required super.id,
    required super.streetAddress,
    required super.floor,
    required super.city,
    required super.region,
    required super.country,
    required super.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      floor: json['floor'] ?? 0,
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'streetAddress': streetAddress,
      'floor': floor,
      'city': city,
      'region': region,
      'country': country,
      'postalCode': postalCode,
    };
  }
}

class BankDetailsModel extends BankDetailsEntity {
  BankDetailsModel({
    required super.id,
    required super.bankName,
    required super.accountNumber,
    required super.accountHolder,
    required super.ifscCode,
    required super.iban,
    required super.swiftCode,
    required super.isPrimary,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountHolder: json['accountHolder'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      iban: json['iban'] ?? '',
      swiftCode: json['swiftCode'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
      'ifscCode': ifscCode,
      'iban': iban,
      'swiftCode': swiftCode,
      'isPrimary': isPrimary,
    };
  }
}