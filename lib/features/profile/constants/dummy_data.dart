// This file contains dummy data for testing purposes
// The actual data now comes from the API endpoint: /store

class DummyData {
  static const Map<String, dynamic> storeData = {
    "store": {
      "id": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
      "posId": 1234568,
      "deliveryPartnerID": [1, 2, 3],
      "storeName": "Test Restaurant",
      "brandName": "Test",
      "businessType": "Restaurant",
      "firstName": "Ajay",
      "lastName": "Jena",
      "contactNumber": "1234567890",
      "email": "test@gmail.com",
      "neighbourhood": "Downtown",
      "cuisineType": "Italian",
      "numberOfLocation": 5,
      "description": "A premium Italian restaurant serving authentic dishes.",
      "websiteUrl": "https://amrutam.com",
      "available": true,
      "status": "ACTIVE",
      "openTime": "10:00",
      "closeTime": "22:00",
      "operatingDays": [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ],
      "createdAt": "2025-07-16T05:07:40.017Z",
      "updateAt": "2025-07-16T05:07:40.017Z",
      "address": {
        "id": "6d0c4681-3203-4243-9315-38c6b6120007",
        "streetAddress": "123 Main Street",
        "floor": 2,
        "city": "New York",
        "region": "NY",
        "country": "USA",
        "postalCode": "10001",
        "latitude": "40.7128",
        "longitude": "-74.006",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "createdAt": "2025-07-16T05:07:40.019Z",
        "updatedAt": "2025-07-16T05:07:40.019Z"
      },
      "bankDetails": [
        {
          "id": "a74d6bbb-844f-4449-b302-65fbaa509b1a",
          "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
          "bankName": "Chase Bank",
          "accountNumber": "1234567890123456",
          "accountHolder": "John Doe",
          "ifscCode": "CHAS0001234",
          "iban": "US12345678901234567890",
          "swiftCode": "CHASUS33",
          "isPrimary": true,
          "createdAt": "2025-07-16T05:07:40.021Z",
          "updateAt": "2025-07-16T05:07:40.021Z"
        }
      ]
    }
  };

  static Map<String, dynamic> get store => storeData["store"] as Map<String, dynamic>;
  static List<dynamic> get bankDetails => store["bankDetails"] as List<dynamic>;
  static Map<String, dynamic> get address => store["address"] as Map<String, dynamic>;
  
  // Helper methods to get formatted data
  static String get fullName => "${store["firstName"]} ${store["lastName"]}";
  static String get fullAddress => 
      "${address["streetAddress"]}, Floor ${address["floor"]}, ${address["city"]}, ${address["region"]}, ${address["country"]} - ${address["postalCode"]}";
  
  static String get operatingHours => "${store["openTime"]} - ${store["closeTime"]}";
  
  static List<String> get allDays => [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];
  
  // Helper to check if a day is operating
  static bool isDayOperating(String day) {
    return (store["operatingDays"] as List<dynamic>).contains(day);
  }
  
  // Helper to mask account number for security
  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return "****${accountNumber.substring(accountNumber.length - 4)}";
  }
  
  // Helper to mask IBAN for security
  static String maskIban(String iban) {
    if (iban.length <= 4) return iban;
    return "****${iban.substring(iban.length - 8)}";
  }
}