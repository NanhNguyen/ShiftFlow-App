import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';

part 'schedule_form_state.freezed.dart';

@freezed
class ScheduleFormState with _$ScheduleFormState {
  const factory ScheduleFormState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    DateTime? startDate,
    DateTime? endDate,
    @Default([]) List<DateTime> selectedDates,
    @Default(['MONDAY']) List<String> selectedWeekdays,
    @Default('MORNING') String shift,
    @Default(false) bool isRecurring,
    @Default('') String description,
    @Default(ScheduleType.WORK) ScheduleType type,
  }) = _ScheduleFormState;
}
