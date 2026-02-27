import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/service/auth_service.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState> {
  final AuthService _authService;

  ProfileCubit(this._authService)
    : super(ProfileState(user: _authService.currentUser));

  Future<void> logout() async {
    setLoading();
    try {
      await _authService.logout();
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> changePassword(String newPassword) async {
    setLoading();
    try {
      await _authService.changePassword(newPassword);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}
