import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'api_client.dart';

@lazySingleton
class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  Future<Response> login(String email, String password) {
    return _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> refresh(String refreshToken) {
    return _apiClient.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
  }

  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _apiClient.post(
      '/users/change-password',
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  Future<Response> getProfile() {
    return _apiClient.get('/auth/profile');
  }
}
