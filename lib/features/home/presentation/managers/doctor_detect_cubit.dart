import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/features/home/data/sources/teeth_detect_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_detect_state.dart';

class DoctorDetectCubit extends Cubit<DoctorDetectState> {
  final DioService service;
  final String token;

  DoctorDetectCubit(this.service, this.token)
    : super(DoctorDetectState.initial());

  // ✅ أضف customerName
  Future<void> detect(File image, String customerName) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await service.detectDoctorTeeth(
        image,
        token,
        customerName, // ✅ REQUIRED
      );

      emit(state.copyWith(isLoading: false, result: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
