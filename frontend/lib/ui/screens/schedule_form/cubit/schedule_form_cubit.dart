import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import 'schedule_form_state.dart';

@injectable
class ScheduleFormCubit extends BaseCubit<ScheduleFormState> {
  final ScheduleRequestRepo _scheduleRepo;

  ScheduleFormCubit(this._scheduleRepo)
    : super(
        ScheduleFormState(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          selectedDates: [],
          selectedWeekdays: ['MONDAY'],
          type: ScheduleType.LEAVE,
        ),
      );

  void setInitialMode({required bool isRecurring}) {
    emit(state.copyWith(isRecurring: isRecurring));
  }

  void updateField({
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? selectedDates,
    List<String>? selectedWeekdays,
    String? shift,
    bool? isRecurring,
    String? description,
    ScheduleType? type,
  }) {
    DateTime? newStart = startDate != null
        ? DateTime(startDate.year, startDate.month, startDate.day)
        : state.startDate;
    DateTime? newEnd = endDate != null
        ? DateTime(endDate.year, endDate.month, endDate.day)
        : state.endDate;

    // Logic: End date must be >= start date
    if (newStart != null && newEnd != null && newEnd.isBefore(newStart)) {
      newEnd = newStart;
    }

    emit(
      state.copyWith(
        startDate: newStart,
        endDate: newEnd,
        selectedDates: selectedDates ?? state.selectedDates,
        selectedWeekdays: selectedWeekdays ?? state.selectedWeekdays,
        shift: shift ?? state.shift,
        isRecurring: isRecurring ?? state.isRecurring,
        description: description ?? state.description,
        type: type ?? state.type,
      ),
    );
  }

  void toggleDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final currentDates = List<DateTime>.from(state.selectedDates);
    if (currentDates.contains(normalizedDate)) {
      currentDates.remove(normalizedDate);
    } else {
      currentDates.add(normalizedDate);
    }
    updateField(selectedDates: currentDates);
  }

  void toggleWeekday(String weekday) {
    final currentWeekdays = List<String>.from(state.selectedWeekdays);
    if (currentWeekdays.contains(weekday)) {
      currentWeekdays.remove(weekday);
    } else {
      currentWeekdays.add(weekday);
    }
    updateField(selectedWeekdays: currentWeekdays);
  }

  Future<void> submit() async {
    final isRecurring = state.isRecurring;

    if (isRecurring) {
      if (state.startDate == null || state.endDate == null) {
        setError('Vui lòng chọn ngày bắt đầu và kết thúc');
        return;
      }
      if (state.selectedWeekdays.isEmpty) {
        setError('Vui lòng chọn ít nhất một thứ trong tuần');
        return;
      }
    } else {
      if (state.selectedDates.isEmpty) {
        setError('Vui lòng chọn ít nhất một ngày nghỉ');
        return;
      }
    }

    setLoading();
    try {
      final groupId = DateTime.now().millisecondsSinceEpoch.toString();

      if (isRecurring) {
        // Create multiple recurring requests, one for each weekday
        final requests = state.selectedWeekdays
            .map(
              (wd) => {
                'description': state.description,
                'start_date': state.startDate!.toIso8601String(),
                'end_date': state.endDate!.toIso8601String(),
                'shift': state.shift,
                'weekday': wd,
                'is_recurring': true,
                'type': state.type.name,
                'groupId': groupId,
              },
            )
            .toList();
        await _scheduleRepo.createSchedule(requests);
      } else {
        // Multi-date individual requests
        final requests = state.selectedDates
            .map(
              (date) => {
                'description': state.description,
                'start_date': date.toIso8601String(),
                'end_date': date.toIso8601String(),
                'shift': state.shift,
                'is_recurring': false,
                'type': state.type.name,
                'weekday': _getWeekdayString(date.weekday),
                'groupId': groupId,
              },
            )
            .toList();
        await _scheduleRepo.createSchedule(requests);
      }
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  String _getWeekdayString(int day) {
    switch (day) {
      case DateTime.monday:
        return 'MONDAY';
      case DateTime.tuesday:
        return 'TUESDAY';
      case DateTime.wednesday:
        return 'WEDNESDAY';
      case DateTime.thursday:
        return 'THURSDAY';
      case DateTime.friday:
        return 'FRIDAY';
      case DateTime.saturday:
        return 'SATURDAY';
      case DateTime.sunday:
        return 'SUNDAY';
      default:
        return 'MONDAY';
    }
  }
}
