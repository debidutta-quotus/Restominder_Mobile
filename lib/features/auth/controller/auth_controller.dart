import 'package:resto_minder/common/services/token_service.dart';
import '../api/auth_api.dart';
import '../model/login_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class AuthController {
  final AuthApi _authApi = AuthApi();
  final TokenService _tokenService = TokenService();

  Future<bool> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authApi.login(request);
      debugPrint('Login response: ${response.data.toJson()}');
      await _tokenService.saveToken(response.data.token);
      debugPrint('Token saved after login: ${response.data.token}');
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow; // Rethrow to allow LoginScreen to handle specific errors
    }
  }

  Future<void> logout() async {
    try {
      await _tokenService.clearToken();
      await _tokenService.clearCredentials();
      await _tokenService.clearRememberMeEnabled();
      debugPrint('Logout completed');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<void> saveCredentials(String email, String password, bool rememberMe) async {
    try {
      await _tokenService.saveRememberMeEnabled(rememberMe);
      if (rememberMe) {
        await _tokenService.saveCredentials(email, password);
        debugPrint('Credentials saved: email=$email, rememberMe=$rememberMe');
      } else {
        debugPrint('RememberMe not enabled, credentials not saved');
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
      rethrow;
    }
  }

  Future<void> clearCredentials() async {
    try {
      await _tokenService.clearCredentials();
      debugPrint('Credentials cleared');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
      rethrow;
    }
  }

  Future<String?> getSavedEmail() async {
    try {
      final email = await _tokenService.getSavedEmail();
      debugPrint('Retrieved saved email: $email');
      return email;
    } catch (e) {
      debugPrint('Error retrieving saved email: $e');
      return null;
    }
  }

  Future<String?> getSavedPassword() async {
    try {
      final password = await _tokenService.getSavedPassword();
      debugPrint('Retrieved saved password: [hidden for security]');
      return password;
    } catch (e) {
      debugPrint('Error retrieving saved password: $e');
      return null;
    }
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      final enabled = await _tokenService.isRememberMeEnabled();
      debugPrint('RememberMe enabled: $enabled');
      return enabled;
    } catch (e) {
      debugPrint('Error checking RememberMe enabled: $e');
      return false;
    }
  }

  // Method to debug token storage and retrieval
  Future<void> debugToken() async {
    try {
      final token = await _tokenService.getToken();
      if (token != null) {
        debugPrint('Debug: Token found in storage: $token');
      } else {
        debugPrint('Debug: No token found in storage');
      }
    } catch (e) {
      debugPrint('Debug: Error accessing token: $e');
    }
  }
}