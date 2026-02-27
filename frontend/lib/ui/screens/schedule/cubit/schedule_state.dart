import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/model/schedule_request_model.dart';

part 'schedule_state.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    @Default([]) List<ScheduleRequestModel> approvedSchedules,
  }) = _ScheduleState;
}
