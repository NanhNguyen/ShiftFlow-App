import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/notification_repo.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _notificationRepo;

  NotificationCubit(this._notificationRepo) : super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: BaseStatus.loading));
    try {
      final notifications = await _notificationRepo.getNotifications();
      emit(
        state.copyWith(
          status: BaseStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BaseStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _notificationRepo.markAsRead(id);
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      // Silently fail or handle error
    }
  }
}
