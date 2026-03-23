import 'package:injectable/injectable.dart';
import '../api/user_api.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';
import 'user_repo.dart';

@LazySingleton(as: UserRepo)
class UserRepoImpl implements UserRepo {
  final UserApi _userApi;

  UserRepoImpl(this._userApi);

  @override
  Future<UserModel> updateProfile({required String name}) async {
    final response = await _userApi.updateProfile(name: name);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> uploadAvatar(XFile file) async {
    final response = await _userApi.uploadAvatar(file);
    return UserModel.fromJson(response.data);
  }
}
