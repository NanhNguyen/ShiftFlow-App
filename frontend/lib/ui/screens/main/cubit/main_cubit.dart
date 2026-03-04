import 'package:injectable/injectable.dart';
import '../../../cubit/base_cubit.dart';
import 'main_state.dart';

@lazySingleton
class MainCubit extends BaseCubit<MainState> {
  MainCubit() : super(const MainState());

  void setIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
