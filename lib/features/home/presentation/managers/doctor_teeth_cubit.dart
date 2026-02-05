import 'dart:io';
import 'package:doctor/features/home/data/sources/doctor_teeth_service.dart';
import 'package:doctor/features/home/data/sources/token_storage.dart';
import 'package:doctor/features/home/presentation/managers/doctor_teeth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorTeethCubit extends Cubit<DoctorTeethState> {
  final DoctorTeethService service;

  DoctorTeethCubit(this.service) : super(DoctorTeethState.initial());

  Future<String> _requireToken() async {
    final token = await TokenStorage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please login first.");
    }
    return token;
  }

  Future<void> create({
    required int pId,
    required String name,
    required int number,
    required String descripe,
    File? photo,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        clearMessage: true,
        clearResults: true,
      ),
    );
    try {
      final token = await _requireToken();
      final tooth = await service.createTooth(
        token: token,
        pId: pId,
        name: name,
        number: number,
        descripe: descripe,
        photo: photo,
      );
      emit(
        state.copyWith(
          isLoading: false,
          message: "Created successfully",
          created: tooth,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateDescripe({
    required int id,
    required String descripe,
    File? photo,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        clearMessage: true,
        clearResults: true,
      ),
    );
    try {
      final token = await _requireToken();
      final tooth = await service.updateDescripe(
        token: token,
        id: id,
        descripe: descripe,
        photo: photo,
      );
      emit(
        state.copyWith(
          isLoading: false,
          message: "Updated successfully",
          updated: tooth,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> delete({required int id}) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        clearMessage: true,
        clearResults: true,
      ),
    );
    try {
      final token = await _requireToken();
      final msg = await service.deleteTooth(token: token, id: id);
      emit(state.copyWith(isLoading: false, message: msg, deletedId: id));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
