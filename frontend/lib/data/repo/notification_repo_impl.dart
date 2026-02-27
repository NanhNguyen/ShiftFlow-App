import 'package:injectable/injectable.dart';
import '../api/notification_api.dart';
import '../model/notification_model.dart';
import 'notification_repo.dart';

@LazySingleton(as: NotificationRepo)
class NotificationRepoImpl implements NotificationRepo {
  final NotificationApi _notificationApi;

  NotificationRepoImpl(this._notificationApi);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _notificationApi.getNotifications();
    final List<dynamic> data = response.data;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _notificationApi.markAsRead(id);
  }
}
