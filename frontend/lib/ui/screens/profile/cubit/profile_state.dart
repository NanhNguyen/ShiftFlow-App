import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/model/user_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(BaseStatus.initial) BaseStatus status,
    String? errorMessage,
    UserModel? user,
  }) = _ProfileState;
}
