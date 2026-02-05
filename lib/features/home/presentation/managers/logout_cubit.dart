import 'package:bloc/bloc.dart';
import 'logout_state.dart';
import '../../data/sources/logout_service.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutService service;

  LogoutCubit(this.service) : super(LogoutState.initial());

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    try {
      await service.logout();
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
