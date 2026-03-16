import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/repo/announcement_repo.dart';
import 'announcement_state.dart';

@injectable
class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepo _repo;

  AnnouncementCubit(this._repo) : super(const AnnouncementState());

  Future<void> loadAnnouncements() async {
    emit(state.copyWith(status: BaseStatus.loading));
    try {
      final items = await _repo.getAnnouncements();
      emit(state.copyWith(status: BaseStatus.success, announcements: items));
    } catch (e) {
      emit(
        state.copyWith(status: BaseStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<bool> createAnnouncement(String title, String content) async {
    emit(state.copyWith(submitStatus: BaseStatus.loading));
    try {
      final newItem = await _repo.createAnnouncement({
        'title': title,
        'content': content,
      });
      emit(
        state.copyWith(
          submitStatus: BaseStatus.success,
          successMessage: 'Đã đăng thông báo thành công!',
          announcements: [newItem, ...state.announcements],
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          submitStatus: BaseStatus.error,
          errorMessage: 'Đăng thông báo thất bại: $e',
        ),
      );
      return false;
    }
  }

  Future<void> markSeen(String id) async {
    try {
      await _repo.markSeen(id);
    } catch (_) {}
  }

  Future<void> deleteAnnouncement(String id) async {
    emit(state.copyWith(submitStatus: BaseStatus.loading));
    try {
      print('DEBUG: Deleting announcement with ID: $id');
      await _repo.deleteAnnouncement(id);
      final newItems = state.announcements
          .where((element) => element.id != id)
          .toList();
      emit(
        state.copyWith(
          announcements: newItems,
          submitStatus: BaseStatus.success,
          successMessage: '🗑️ Đã xóa thông báo khỏi hệ thống!',
        ),
      );
    } catch (e) {
      print('DEBUG: Error deleting announcement: $e');
      emit(
        state.copyWith(
          submitStatus: BaseStatus.error,
          errorMessage: 'Xóa thông báo thất bại: $e',
        ),
      );
    }
  }
}
