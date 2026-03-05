import '../model/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<String?> refresh(String refreshToken);
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<UserModel> getProfile();
}
