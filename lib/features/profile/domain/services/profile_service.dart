import '../entities/store_entity.dart';

class ProfileService {
  // Utility methods for profile-related operations
  
  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return "****${accountNumber.substring(accountNumber.length - 4)}";
  }
  
  static String maskIban(String iban) {
    if (iban.length <= 4) return iban;
    return "****${iban.substring(iban.length - 8)}";
  }
  
  static bool isDayOperating(List<String> operatingDays, String day) {
    return operatingDays.contains(day);
  }
  
  static List<String> getAllDays() {
    return [
      "Monday", "Tuesday", "Wednesday", "Thursday", 
      "Friday", "Saturday", "Sunday"
    ];
  }
  
  static bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool validatePhoneNumber(String phone) {
    return RegExp(r'^\d{10}$').hasMatch(phone);
  }
  
  static bool validateUrl(String url) {
    return RegExp(r'^https?:\/\/.+').hasMatch(url);
  }
  
  static String formatOperatingHours(String openTime, String closeTime) {
    return '$openTime - $closeTime';
  }
  
  static BankDetailsEntity? getPrimaryBank(List<BankDetailsEntity> bankDetails) {
    try {
      return bankDetails.firstWhere((bank) => bank.isPrimary);
    } catch (e) {
      return bankDetails.isNotEmpty ? bankDetails.first : null;
    }
  }
}