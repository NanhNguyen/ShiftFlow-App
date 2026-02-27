// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['_id'] as String,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  isRead: json['is_read'] as bool,
  type: json['type'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'is_read': instance.isRead,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
};
