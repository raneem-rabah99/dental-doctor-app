import 'package:doctor/features/home/presentation/managers/today_approved_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/sources/today_approved_service.dart';

class TodayApprovedCubit extends Cubit<TodayApprovedState> {
  final TodayApprovedService service;

  TodayApprovedCubit(this.service) : super(TodayApprovedState.initial());

  Future<void> loadtodayapproved() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await service.fetchTodayApproved();
      if (isClosed) return; // ✅
      emit(state.copyWith(isLoading: false, cases: data));
    } catch (e) {
      if (isClosed) return; // ✅ ناقصة
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
