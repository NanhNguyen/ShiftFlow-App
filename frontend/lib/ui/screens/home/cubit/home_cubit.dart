import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/service/auth_service.dart';
import '../../../../data/repo/notification_repo.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../di/di_config.dart';
import '../../notifications/cubit/notification_cubit.dart';
import 'home_state.dart';

@lazySingleton
class HomeCubit extends BaseCubit<HomeState> {
  final ScheduleRequestRepo _scheduleRepo;
  final NotificationRepo _notificationRepo;
  final AuthService _authService;

  HomeCubit(this._authService, this._scheduleRepo, this._notificationRepo)
    : super(HomeState(user: _authService.currentUser));

  Future<void> loadData() async {
    safeCall(() async {
      final currentUser = _authService.currentUser;
      final isManagerOrHR =
          currentUser?.role == UserRole.MANAGER ||
          currentUser?.role == UserRole.HR;

      final notifCubit = getIt<NotificationCubit>();
      final results = await Future.wait([
        if (!isManagerOrHR)
          _scheduleRepo.getMySchedules()
        else
          Future.value(<ScheduleRequestModel>[]),
        notifCubit.loadNotifications(),
        if (isManagerOrHR)
          _scheduleRepo.getAllSchedules()
        else
          Future.value(<ScheduleRequestModel>[]),
      ]);

      final mySchedules = results[0] as List<ScheduleRequestModel>;
      // notifications don't come from results[1] anymore, they are in notifCubit.state
      final notifications = notifCubit.state.notifications;
      final allSchedules = results[2] as List<ScheduleRequestModel>;

      // Manager/HR: count ALL pending; Intern: count their own pending
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
          user: currentUser,
          pendingCount: pending,
          totalCount: mySchedules.length,
          unreadNotificationCount: unreadCount,
          todaySchedule: todaySchedule,
        ),
      );
    });
  }
}
