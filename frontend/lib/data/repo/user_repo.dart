import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';

abstract class UserRepo {
  Future<UserModel> updateProfile({required String name});
  Future<UserModel> uploadAvatar(XFile file);
}
