import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'api_client.dart';

@lazySingleton
class UserApi {
  final ApiClient _apiClient;

  UserApi(this._apiClient);

  Future<Response> updateProfile({required String name}) {
    return _apiClient.post('/users/update-profile', data: {'name': name});
  }

  Future<Response> uploadAvatar(XFile file) async {
    final bytes = await file.readAsBytes();
    final fileName = file.name;
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    return _apiClient.post('/users/upload-avatar', data: formData);
  }
}
