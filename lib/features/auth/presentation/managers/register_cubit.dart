import 'package:doctor/features/auth/data/sources/register_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_model.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterService registerService;

  // ✅ holds the latest user data from a successful registration
  Map<String, dynamic>? lastUserData;

  RegisterCubit(this.registerService) : super(RegisterState.initial());

  Future<void> registerUser(RegisterModel model) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      final response = await registerService.register(model);

      if (response['status'] == true) {
        // ✅ Save user & token for later use (e.g., in the UI)
        lastUserData = {'user': response['user'], 'token': response['token']};

        emit(
          state.copyWith(isLoading: false, successMessage: response['message']),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response['message'] ?? 'Registration failed',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
