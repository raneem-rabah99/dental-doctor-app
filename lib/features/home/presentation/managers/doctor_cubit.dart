import 'package:doctor/features/home/data/sources/doctor_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanoramaTeethCubit extends Cubit<PanoramaTeethState> {
  final PanoramaTeethService service;

  PanoramaTeethCubit(this.service) : super(PanoramaTeethState.initial());

  Future<void> loadData({
    required String token,
    required int customerId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await service.fetchPanoramaTeeth(customerId: customerId);
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, data: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
