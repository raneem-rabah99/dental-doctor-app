import 'package:doctor/features/auth/data/sources/login_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/login_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService loginService;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Map<String, dynamic>? lastUserData;

  LoginCubit(this.loginService) : super(LoginState.initial());

  Future<void> loginUser(LoginModel model) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      final response = await loginService.login(model);

      if (response['status'] == true) {
        final user = response['user'];
        final token = response['token'];

        // Save user data for session
        lastUserData = {'user': user, 'token': token};

        // 🔥 SAVE TO SECURE STORAGE
        await secureStorage.write(key: "username", value: user["first_name"]);
        await secureStorage.write(
          key: "image",
          value: user["photo"],
        ); // << IMPORTANT
        await secureStorage.write(key: "token", value: token);

        emit(
          state.copyWith(isLoading: false, successMessage: response['message']),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response['message'] ?? "Login failed",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
