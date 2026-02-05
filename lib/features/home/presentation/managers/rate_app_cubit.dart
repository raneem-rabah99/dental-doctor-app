import 'package:flutter_bloc/flutter_bloc.dart';
import 'rate_app_state.dart';
import '../../data/sources/rate_app_service.dart';

class RateAppCubit extends Cubit<RateAppState> {
  final RateAppService service;

  RateAppCubit(this.service) : super(RateAppState.initial());

  Future<void> rateApp({required int rate, required String feedback}) async {
    emit(state.copyWith(isLoading: true, success: null, error: null));

    try {
      final response = await service.sendRate(rate: rate, feedback: feedback);
      if (isClosed) return;
      if (response["status"] == true) {
        emit(
          state.copyWith(
            isLoading: false,
            success: response["message"] ?? "Thank you!",
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response["message"] ?? "Failed to submit rating",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
