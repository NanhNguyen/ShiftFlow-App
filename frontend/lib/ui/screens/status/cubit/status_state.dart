import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/model/schedule_request_model.dart';

part 'status_state.freezed.dart';

@freezed
class StatusState with _$StatusState {
  const factory StatusState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    @Default([]) List<ScheduleRequestModel> requests,
  }) = _StatusState;
}
