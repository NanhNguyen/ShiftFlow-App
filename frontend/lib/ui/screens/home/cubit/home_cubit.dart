import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/service/auth_service.dart';
import '../../../../data/repo/notification_repo.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import '../../../../data/model/schedule_request_model.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final ScheduleRequestRepo _scheduleRepo;
  final NotificationRepo _notificationRepo;

  HomeCubit(AuthService authService, this._scheduleRepo, this._notificationRepo)
    : super(HomeState(user: authService.currentUser));

  Future<void> loadData() async {
    setLoading();
    try {
      final user = state.user;
      final isManagerOrHR =
          user?.role == UserRole.MANAGER || user?.role == UserRole.HR;

      final results = await Future.wait([
        _scheduleRepo.getMySchedules(),
        _notificationRepo.getNotifications(),
        if (isManagerOrHR) _scheduleRepo.getAllSchedules(),
      ]);

      final mySchedules = results[0] as List<ScheduleRequestModel>;
      final notifications = results[1] as List<dynamic>;

      List<ScheduleRequestModel> allSchedules = [];
      if (isManagerOrHR && results.length > 2) {
        allSchedules = results[2] as List<ScheduleRequestModel>;
      }

      // If manager, pendingCount should reflect ALL pending requests
      final schedulesForCount = isManagerOrHR ? allSchedules : mySchedules;
      final pendingList = schedulesForCount
          .where((s) => s.status == RequestStatus.PENDING)
          .toList();

      final pending = pendingList.groupByGroupId().length;

      final unreadCount = notifications.where((n) => !n.isRead).length;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      ScheduleRequestModel? todaySchedule;
      try {
        todaySchedule = mySchedules.firstWhere(
          (s) =>
              s.status == RequestStatus.APPROVED &&
              s.startDate.isBefore(today.add(const Duration(days: 1))) &&
              s.endDate.isAfter(today.subtract(const Duration(seconds: 1))),
        );
      } catch (_) {
        todaySchedule = null;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          pendingCount: pending,
          totalCount: mySchedules.length,
          unreadNotificationCount: unreadCount,
          todaySchedule: todaySchedule,
        ),
      );
    } catch (e) {
      setError(e.toString());
    }
  }
}
