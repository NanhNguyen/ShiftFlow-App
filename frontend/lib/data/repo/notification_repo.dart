import '../model/notification_model.dart';

abstract class NotificationRepo {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}
