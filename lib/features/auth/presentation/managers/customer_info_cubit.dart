import 'package:doctor/features/auth/data/models/customer_info_model.dart';
import 'package:doctor/features/auth/data/sources/customer_info_service.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorProfileService service;

  DoctorProfileCubit(this.service) : super(DoctorProfileState.initial());

  Future<void> submitProfile(DoctorProfileModel model) async {
    emit(state.copyWith(isLoading: true, error: null, success: null));

    try {
      final response = await service.uploadDoctorProfile(model);

      if (response['status'] == true) {
        emit(state.copyWith(isLoading: false, success: response['message']));
      } else {
        emit(state.copyWith(isLoading: false, error: response['message']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
