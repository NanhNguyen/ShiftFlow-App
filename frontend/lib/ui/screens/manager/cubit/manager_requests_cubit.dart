import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import 'manager_requests_state.dart';

@injectable
class ManagerRequestsCubit extends BaseCubit<ManagerRequestsState> {
  final ScheduleRequestRepo _scheduleRepo;

  ManagerRequestsCubit(this._scheduleRepo)
    : super(const ManagerRequestsState());

  Future<void> loadAllRequests() async {
    setLoading();
    try {
      final res = await _scheduleRepo.getAllSchedules();
      emit(state.copyWith(status: BaseStatus.success, requests: res));
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> approveRequest(String id) async {
    try {
      await _scheduleRepo.updateStatus(id, 'APPROVED');
      await loadAllRequests();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> rejectRequest(String id) async {
    try {
      await _scheduleRepo.updateStatus(id, 'REJECTED');
      await loadAllRequests();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> approveBatch(String groupId) async {
    try {
      await _scheduleRepo.updateBatchStatus(groupId, 'APPROVED');
      await loadAllRequests();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> rejectBatch(String groupId) async {
    try {
      await _scheduleRepo.updateBatchStatus(groupId, 'REJECTED');
      await loadAllRequests();
    } catch (e) {
      setError(e.toString());
    }
  }
}
