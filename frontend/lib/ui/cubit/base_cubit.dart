import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/constant/enums.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  // Helper methods to reduce boilerplate in child cubits
  void setLoading() {
    try {
      emit((state as dynamic).copyWith(status: BaseStatus.loading));
    } catch (_) {}
  }

  void setSuccess() {
    try {
      emit((state as dynamic).copyWith(status: BaseStatus.success));
    } catch (_) {}
  }

  void setError(String message) {
    try {
      emit(
        (state as dynamic).copyWith(
          status: BaseStatus.error,
          errorMessage: message,
        ),
      );
    } catch (_) {}
  }
}
