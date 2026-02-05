import 'dart:io';

import 'package:doctor/features/home/data/sources/update_photo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_photo_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdatePhotoCubit extends Cubit<UpdatePhotoState> {
  final UpdatePhotoService service;
  final _storage = const FlutterSecureStorage();

  UpdatePhotoCubit(this.service) : super(UpdatePhotoState.initial());

  Future<void> updatePhoto(File file) async {
    if (state.isLoading) return; // ⛔ prevent double actions

    if (isClosed) return;
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    final response = await service.uploadPhoto(file);

    if (isClosed) return;

    if (response.status == true && response.photoUrl != null) {
      await _storage.write(key: 'image', value: response.photoUrl);

      emit(state.copyWith(isLoading: false, successMessage: response.message));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: response.message));
    }
  }
}
