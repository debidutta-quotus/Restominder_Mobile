import '../entities/store_entity.dart';
import '../../data/repositories/profile_repository.dart';

class UpdateStoreProfile {
  final ProfileRepository _repository;

  UpdateStoreProfile(this._repository);

  Future<StoreEntity> call(Map<String, dynamic> profileData) async {
    try {
      // Validate required fields
      if (profileData['storeName']?.isEmpty ?? true) {
        throw Exception('Store name is required');
      }
      if (profileData['email']?.isEmpty ?? true) {
        throw Exception('Email is required');
      }
      if (profileData['contactNumber']?.isEmpty ?? true) {
        throw Exception('Contact number is required');
      }

      return await _repository.updateStoreProfile(profileData);
    } catch (e) {
      throw Exception('UseCase: Failed to update store profile - $e');
    }
  }
}