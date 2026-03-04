import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/model/schedule_request_model.dart';

part 'manager_requests_state.freezed.dart';

@freezed
class ManagerRequestsState with _$ManagerRequestsState {
  const factory ManagerRequestsState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    @Default([]) List<ScheduleRequestModel> requests,
    String? actionResult, // 'APPROVED' | 'REJECTED' | null
  }) = _ManagerRequestsState;
}
