import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/model/notification_model.dart';
import '../../../../data/constant/enums.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<NotificationModel> notifications,
    String? errorMessage,
  }) = _NotificationState;
}
