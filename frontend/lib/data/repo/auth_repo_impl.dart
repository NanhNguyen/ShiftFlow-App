import 'dart:developer' as dev;
import 'package:injectable/injectable.dart';
import '../api/auth_api.dart';
import '../model/user_model.dart';
import '../../foundation/storage/token_storage.dart';
import 'auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  AuthRepoImpl(this._authApi, this._tokenStorage);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _authApi.login(email, password);
      final data = response.data;

      if (data == null) {
        throw Exception('Response data is null');
      }

      await _tokenStorage.saveTokens(
        accessToken: data['access_token'] ?? '',
        refreshToken: data['refresh_token'] ?? '',
      );

      return UserModel.fromJson(data['user']);
    } catch (e) {
      dev.log('Login error in AuthRepoImpl: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<String?> refresh(String refreshToken) async {
    final response = await _authApi.refresh(refreshToken);
    final newToken = response.data['access_token'];
    await _tokenStorage.saveAccessToken(newToken);
    return newToken;
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await _authApi.changePassword(newPassword);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await _authApi.getProfile();
    return UserModel.fromJson(response.data);
  }
}
