import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import '../../../../data/service/auth_service.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      setError('Please enter both email and password');
      return;
    }

    setLoading();
    try {
      await _authService.login(email, password);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}
