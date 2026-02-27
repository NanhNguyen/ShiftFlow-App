import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    @Default(true) bool obscurePassword,
    @Default(false) bool rememberMe,
  }) = _LoginState;
}
