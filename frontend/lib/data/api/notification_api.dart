import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'api_client.dart';

@lazySingleton
class NotificationApi {
  final ApiClient _apiClient;

  NotificationApi(this._apiClient);

  Future<Response> getNotifications() {
    return _apiClient.get('/notifications');
  }

  Future<Response> markAsRead(String id) {
    return _apiClient.patch('/notifications/$id/read');
  }
}
