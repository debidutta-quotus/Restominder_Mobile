import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: StorageKeys.authToken, value: token);
      debugPrint('Token saved successfully: $token');
    } catch (e) {
      debugPrint('Error saving token: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: StorageKeys.authToken);
      debugPrint('Retrieved token: $token');
      return token;
    } catch (e) {
      debugPrint('Error retrieving token: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: StorageKeys.authToken);
      debugPrint('Token cleared successfully');
    } catch (e) {
      debugPrint('Error clearing token: $e');
      rethrow;
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    try {
      await _storage.write(key: StorageKeys.savedEmail, value: email);
      await _storage.write(key: StorageKeys.savedPassword, value: password);
      debugPrint('Credentials saved: email=$email');
    } catch (e) {
      debugPrint('Error saving credentials: $e');
      rethrow;
    }
  }

  Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: StorageKeys.savedEmail);
      await _storage.delete(key: StorageKeys.savedPassword);
      debugPrint('Credentials cleared successfully');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
      rethrow;
    }
  }

  Future<String?> getSavedEmail() async {
    try {
      final email = await _storage.read(key: StorageKeys.savedEmail);
      debugPrint('Retrieved saved email: $email');
      return email;
    } catch (e) {
      debugPrint('Error retrieving saved email: $e');
      return null;
    }
  }

  Future<String?> getSavedPassword() async {
    try {
      final password = await _storage.read(key: StorageKeys.savedPassword);
      debugPrint('Retrieved saved password: [hidden for security]');
      return password;
    } catch (e) {
      debugPrint('Error retrieving saved password: $e');
      return null;
    }
  }

  Future<void> saveRememberMeEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: StorageKeys.rememberMeEnabled,
        value: enabled.toString(),
      );
      debugPrint('RememberMe enabled saved: $enabled');
    } catch (e) {
      debugPrint('Error saving RememberMe enabled: $e');
      rethrow;
    }
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      final value = await _storage.read(key: StorageKeys.rememberMeEnabled);
      final enabled = value == 'true';
      debugPrint('Retrieved RememberMe enabled: $enabled');
      return enabled;
    } catch (e) {
      debugPrint('Error retrieving RememberMe enabled: $e');
      return false;
    }
  }

  Future<void> clearRememberMeEnabled() async {
    try {
      await _storage.delete(key: StorageKeys.rememberMeEnabled);
      debugPrint('RememberMe enabled cleared successfully');
    } catch (e) {
      debugPrint('Error clearing RememberMe enabled: $e');
      rethrow;
    }
  }
}