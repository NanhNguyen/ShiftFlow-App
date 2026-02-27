import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import '../../../../data/model/schedule_request_model.dart';
import 'schedule_state.dart';

@injectable
class ScheduleCubit extends BaseCubit<ScheduleState> {
  final ScheduleRequestRepo _scheduleRepo;

  ScheduleCubit(this._scheduleRepo) : super(const ScheduleState());

  Future<void> loadSchedules(UserRole role) async {
    setLoading();
    try {
      List<ScheduleRequestModel> schedules;
      if (role == UserRole.MANAGER || role == UserRole.HR) {
        // Managers and HR see everything (Approved + Pending) to know who registered
        schedules = await _scheduleRepo.getAllSchedules();
      } else {
        // Interns see their own schedules
        schedules = await _scheduleRepo.getMySchedules();
        // Maybe only show approved on the final calendar?
        // Or keep all but display differently. Let's keep all for now.
      }
      emit(
        state.copyWith(
          status: BaseStatus.success,
          approvedSchedules: schedules,
        ),
      );
    } catch (e) {
      setError(e.toString());
    }
  }
}
