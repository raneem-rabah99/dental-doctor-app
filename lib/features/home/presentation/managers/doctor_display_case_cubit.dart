import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor/features/home/data/models/doctor_display_case_model.dart';
import 'package:doctor/features/home/data/sources/doctor_display_case_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_display_case_state.dart';

class DoctorDisplayCaseCubit extends Cubit<DoctorDisplayCaseState> {
  final DoctorDisplayCaseService service;

  DoctorDisplayCaseCubit(this.service) : super(const DoctorDisplayCaseState());

  // ===============================
  // LOAD ALL CASES
  // ===============================
  Future<void> loadDisplayCases() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final list = await service.getDisplayCases();
      if (isClosed) return;
      final cases =
          list.map((e) => DoctorDisplayCaseModel.fromJson(e)).toList();

      emit(state.copyWith(isLoading: false, cases: cases));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ===============================
  // UPLOAD CASE
  // ===============================
  Future<void> uploadDisplayCase({
    required File beforeImage,
    required File afterImage,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final json = await service.uploadDisplayCase(
        beforeImage: beforeImage,
        afterImage: afterImage,
      );
      if (isClosed) return;
      final newCase = DoctorDisplayCaseModel.fromJson(json);

      emit(
        state.copyWith(
          isLoading: false,
          cases: [...state.cases, newCase],
          successMessage: "Display case uploaded successfully.",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ===============================
  // DELETE CASE  ✅ (ONLY NEW PART)
  // ===============================
  Future<void> deleteCase(int id) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await service.deleteDisplayCase(displayCaseId: id);
      if (isClosed) return;
      final updatedList = state.cases.where((item) => item.id != id).toList();

      emit(
        state.copyWith(
          isLoading: false,
          cases: updatedList,
          successMessage: "Display case deleted successfully.",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> setFavorite(int id, int favoriteFlag) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final json = await service.setFavoriteDisplayCase(
        displayCaseId: id,
        favoriteFlag: favoriteFlag,
      );
      if (isClosed) return;
      final updatedCase = DoctorDisplayCaseModel.fromJson(json);

      final updatedList =
          state.cases.map((item) {
            if (item.id == updatedCase.id) {
              return updatedCase; // ✅ replace only this item
            }
            return item;
          }).toList();

      emit(
        state.copyWith(
          isLoading: false,
          cases: updatedList,
          successMessage: "Favorite updated successfully.",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
