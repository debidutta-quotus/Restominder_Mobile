import 'package:flutter/material.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/usecases/get_store_profile.dart';
import '../../domain/usecases/update_store_profile.dart';
import '../../domain/usecases/manage_bank_details.dart';
import '../../constants/dummy_data.dart';
import '../../data/models/store_model.dart';

class ProfileProvider extends ChangeNotifier {
  final GetStoreProfile _getStoreProfile;
  final UpdateStoreProfile _updateStoreProfile;
  final ManageBankDetails _manageBankDetails;

  ProfileProvider(
    this._getStoreProfile,
    this._updateStoreProfile,
    this._manageBankDetails,
  );

  StoreEntity? _store;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedBankIndex = 0;

  // Getters
  StoreEntity? get store => _store;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedBankIndex => _selectedBankIndex;

  List<BankDetailsEntity> get bankDetails => _store?.bankDetails ?? [];
  BankDetailsEntity? get currentBank => 
      bankDetails.isNotEmpty ? bankDetails[_selectedBankIndex] : null;

  // Initialize with dummy data for now
  void initializeWithDummyData() {
    try {
      _store = StoreModel.fromJson(DummyData.storeData["store"]);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize profile data';
      notifyListeners();
    }
  }

  // Load store profile
  Future<void> loadStoreProfile() async {
    try {
      _setLoading(true);
      _store = await _getStoreProfile.call();
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update store profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _setLoading(true);
      _store = await _updateStoreProfile.call(profileData);
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add bank details
  Future<bool> addBankDetails(Map<String, dynamic> bankData) async {
    try {
      _setLoading(true);
      _store = await _manageBankDetails.addBankDetails(bankData);
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update bank details
  Future<bool> updateBankDetails(String bankId, Map<String, dynamic> bankData) async {
    try {
      _setLoading(true);
      _store = await _manageBankDetails.updateBankDetails(bankId, bankData);
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete bank details
  Future<bool> deleteBankDetails(String bankId) async {
    try {
      _setLoading(true);
      final success = await _manageBankDetails.deleteBankDetails(bankId);
      if (success) {
        // Reload profile to get updated bank details
        await loadStoreProfile();
      }
      _clearError();
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select bank
  void selectBank(int index) {
    if (index >= 0 && index < bankDetails.length) {
      _selectedBankIndex = index;
      notifyListeners();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh profile data
  Future<void> refresh() async {
    await loadStoreProfile();
  }
}