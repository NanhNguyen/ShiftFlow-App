import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String message,
    @JsonKey(name: 'is_read') required bool isRead,
    required String type,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
