import 'package:resto_minder/common/api_manager/api_manager.dart';
import 'package:resto_minder/features/auth/model/login_model.dart';

class AuthApi {
  final ApiManager _apiManager = ApiManager.base();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiManager.postRequest(
        '/store/login',
        request.toJson(),
      );
      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}