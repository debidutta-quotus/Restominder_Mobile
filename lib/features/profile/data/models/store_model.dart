// store_model.dart (updated)
import '../../domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required super.id,
    super.posId,
    super.deliveryPartnerID,
    required super.storeName,
    required super.brandName,
    required super.businessType,
    required super.firstName,
    required super.lastName,
    required super.contactNumber,
    required super.email,
    required super.neighbourhood,
    required super.cuisineType,
    super.numberOfLocation,
    super.description,
    super.websiteUrl,
    super.available,
    super.status,
    required super.openTime,
    required super.closeTime,
    required super.operatingDays,
    super.createdAt,
    super.updateAt,
    required super.address,
    required super.bankDetails,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      posId: json['posId'],
      deliveryPartnerID: List<int>.from(json['deliveryPartnerID'] ?? []),
      storeName: json['storeName'] ?? '',
      brandName: json['brandName'] ?? '',
      businessType: json['businessType'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      neighbourhood: json['neighbourhood'] ?? '',
      cuisineType: json['cuisineType'] ?? '',
      numberOfLocation: json['numberOfLocation'],
      description: json['description'],
      websiteUrl: json['websiteUrl'],
      available: json['available'],
      status: json['status'],
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      operatingDays: List<String>.from(json['operatingDays'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
      address: AddressModel.fromJson(json['address'] ?? {}),
      bankDetails: (json['bankDetails'] as List<dynamic>?)
          ?.map((bank) => BankDetailsModel.fromJson(bank))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posId': posId,
      'deliveryPartnerID': deliveryPartnerID,
      'storeName': storeName,
      'brandName': brandName,
      'businessType': businessType,
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'email': email,
      'neighbourhood': neighbourhood,
      'cuisineType': cuisineType,
      'numberOfLocation': numberOfLocation,
      'description': description,
      'websiteUrl': websiteUrl,
      'available': available,
      'status': status,
      'openTime': openTime,
      'closeTime': closeTime,
      'operatingDays': operatingDays,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
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
    super.latitude,
    super.longitude,
    super.storeId,
    super.createdAt,
    super.updatedAt,
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
      latitude: json['latitude'],
      longitude: json['longitude'],
      storeId: json['storeId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
      'latitude': latitude,
      'longitude': longitude,
      'storeId': storeId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class BankDetailsModel extends BankDetailsEntity {
  BankDetailsModel({
    required super.id,
    required super.storeId,
    required super.bankName,
    required super.accountNumber,
    required super.accountHolder,
    required super.ifscCode,
    required super.iban,
    required super.swiftCode,
    required super.isPrimary,
    super.createdAt,
    super.updateAt,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id'] ?? '',
      storeId: json['storeId'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountHolder: json['accountHolder'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      iban: json['iban'] ?? '',
      swiftCode: json['swiftCode'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
      'ifscCode': ifscCode,
      'iban': iban,
      'swiftCode': swiftCode,
      'isPrimary': isPrimary,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
    };
  }
}