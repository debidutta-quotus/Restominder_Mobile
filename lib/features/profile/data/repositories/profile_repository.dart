import '../../domain/entities/store_entity.dart';
import '../api/profile_api.dart';
// import '../models/store_model.dart';

abstract class ProfileRepository {
  Future<StoreEntity> getStoreProfile();
  Future<StoreEntity> updateStoreProfile(Map<String, dynamic> profileData);
  Future<String> updateStoreImage(String imagePath);
  Future<StoreEntity> addBankDetails(Map<String, dynamic> bankData);
  Future<StoreEntity> updateBankDetails(String bankId, Map<String, dynamic> bankData);
  Future<bool> deleteBankDetails(String bankId);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi _profileApi;

  ProfileRepositoryImpl(this._profileApi);

  @override
  Future<StoreEntity> getStoreProfile() async {
    try {
      return await _profileApi.getStoreProfile();
    } catch (e) {
      throw Exception('Repository: Failed to get store profile - $e');
    }
  }

  @override
  Future<StoreEntity> updateStoreProfile(Map<String, dynamic> profileData) async {
    try {
      return await _profileApi.updateStoreProfile(profileData);
    } catch (e) {
      throw Exception('Repository: Failed to update store profile - $e');
    }
  }

  @override
  Future<String> updateStoreImage(String imagePath) async {
    try {
      return await _profileApi.updateStoreImage(imagePath);
    } catch (e) {
      throw Exception('Repository: Failed to update store image - $e');
    }
  }

  @override
  Future<StoreEntity> addBankDetails(Map<String, dynamic> bankData) async {
    try {
      return await _profileApi.addBankDetails(bankData);
    } catch (e) {
      throw Exception('Repository: Failed to add bank details - $e');
    }
  }

  @override
  Future<StoreEntity> updateBankDetails(String bankId, Map<String, dynamic> bankData) async {
    try {
      return await _profileApi.updateBankDetails(bankId, bankData);
    } catch (e) {
      throw Exception('Repository: Failed to update bank details - $e');
    }
  }

  @override
  Future<bool> deleteBankDetails(String bankId) async {
    try {
      return await _profileApi.deleteBankDetails(bankId);
    } catch (e) {
      throw Exception('Repository: Failed to delete bank details - $e');
    }
  }
}