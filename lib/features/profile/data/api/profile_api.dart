// profile_api.dart (unchanged)
import '../../../../common/api_manager/api_manager.dart';
import '../models/store_model.dart';

class ProfileApi {
  final ApiManager _apiManager = ApiManager.base();

  // Get store profile
  Future<StoreModel> getStoreProfile() async {
    try {
      final response = await _apiManager.getRequest('/store');
      
      if (response['success'] == true && response['data'] != null && response['data']['store'] != null) {
        return StoreModel.fromJson(response['data']['store']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch store profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch store profile: $e');
    }
  }

  // Update store profile
  Future<StoreModel> updateStoreProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiManager.putRequest('/store', profileData);
      
      if (response['success'] == true && response['data'] != null && response['data']['store'] != null) {
        return StoreModel.fromJson(response['data']['store']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update store profile');
      }
    } catch (e) {
      throw Exception('Failed to update store profile: $e');
    }
  }

  // Update store image
  Future<String> updateStoreImage(String imagePath) async {
    try {
      final response = await _apiManager.postRequest('/store/image', {
        'image': imagePath,
      });
      
      if (response['imageUrl'] != null) {
        return response['imageUrl'];
      } else {
        throw Exception(response['message'] ?? 'Failed to update store image');
      }
    } catch (e) {
      throw Exception('Failed to update store image: $e');
    }
  }

  // Add bank details
  Future<StoreModel> addBankDetails(Map<String, dynamic> bankData) async {
    try {
      final response = await _apiManager.postRequest('/store/bank-details', bankData);
      
      if (response['success'] == true && response['data'] != null && response['data']['store'] != null) {
        return StoreModel.fromJson(response['data']['store']);
      } else {
        throw Exception(response['message'] ?? 'Failed to add bank details');
      }
    } catch (e) {
      throw Exception('Failed to add bank details: $e');
    }
  }

  // Update bank details
  Future<StoreModel> updateBankDetails(String bankId, Map<String, dynamic> bankData) async {
    try {
      final response = await _apiManager.putRequest('/store/bank-details/$bankId', bankData);
      
      if (response['success'] == true && response['data'] != null && response['data']['store'] != null) {
        return StoreModel.fromJson(response['data']['store']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update bank details');
      }
    } catch (e) {
      throw Exception('Failed to update bank details: $e');
    }
  }

  // Delete bank details
  Future<bool> deleteBankDetails(String bankId) async {
    try {
      final response = await _apiManager.deleteRequest('/store/bank-details/$bankId');
      
      return response['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete bank details: $e');
    }
  }
}