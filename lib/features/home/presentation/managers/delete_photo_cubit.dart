import 'package:bloc/bloc.dart';
import 'package:doctor/features/home/data/sources/delete_photo_service.dart';
import 'delete_photo_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeletePhotoCubit extends Cubit<DeletePhotoState> {
  final DeletePhotoService deletePhotoService;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  DeletePhotoCubit(this.deletePhotoService) : super(DeletePhotoState.initial());

  Future<void> deletePhoto() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await deletePhotoService.deletePhoto();

      if (isClosed) return;

      if (result.deleted) {
        await storage.delete(key: 'image');

        emit(state.copyWith(isLoading: false, successMessage: result.message));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: result.message));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
