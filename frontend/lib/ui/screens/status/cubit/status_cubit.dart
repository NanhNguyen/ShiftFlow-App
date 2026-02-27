import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import 'status_state.dart';

@injectable
class StatusCubit extends BaseCubit<StatusState> {
  final ScheduleRequestRepo _scheduleRepo;

  StatusCubit(this._scheduleRepo) : super(const StatusState());

  Future<void> loadRequests() async {
    setLoading();
    try {
      final res = await _scheduleRepo.getMySchedules();
      emit(state.copyWith(status: BaseStatus.success, requests: res));
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> deleteRequest(String id) async {
    try {
      await _scheduleRepo.deleteSchedule(id);
      await loadRequests();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> deleteBatchRequests(String groupId) async {
    try {
      await _scheduleRepo.deleteBatchSchedules(groupId);
      await loadRequests();
    } catch (e) {
      setError(e.toString());
    }
  }
}
