import '../entities/store_entity.dart';
import '../../data/repositories/profile_repository.dart';

class ManageBankDetails {
  final ProfileRepository _repository;

  ManageBankDetails(this._repository);

  Future<StoreEntity> addBankDetails(Map<String, dynamic> bankData) async {
    try {
      // Validate required fields
      if (bankData['bankName']?.isEmpty ?? true) {
        throw Exception('Bank name is required');
      }
      if (bankData['accountNumber']?.isEmpty ?? true) {
        throw Exception('Account number is required');
      }
      if (bankData['accountHolder']?.isEmpty ?? true) {
        throw Exception('Account holder name is required');
      }
      if (bankData['ifscCode']?.isEmpty ?? true) {
        throw Exception('IFSC code is required');
      }

      return await _repository.addBankDetails(bankData);
    } catch (e) {
      throw Exception('UseCase: Failed to add bank details - $e');
    }
  }

  Future<StoreEntity> updateBankDetails(String bankId, Map<String, dynamic> bankData) async {
    try {
      if (bankId.isEmpty) {
        throw Exception('Bank ID is required');
      }

      return await _repository.updateBankDetails(bankId, bankData);
    } catch (e) {
      throw Exception('UseCase: Failed to update bank details - $e');
    }
  }

  Future<bool> deleteBankDetails(String bankId) async {
    try {
      if (bankId.isEmpty) {
        throw Exception('Bank ID is required');
      }

      return await _repository.deleteBankDetails(bankId);
    } catch (e) {
      throw Exception('UseCase: Failed to delete bank details - $e');
    }
  }
}