import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/auth/data/models/login_model.dart';
import 'package:doctor/features/auth/data/sources/login_service.dart';
import 'package:doctor/features/auth/presentation/managers/login_cubit.dart';
import 'package:doctor/features/auth/presentation/managers/login_state.dart';
import 'package:doctor/features/auth/presentation/pages/sign_up.dart';
import 'package:doctor/features/auth/presentation/widgets/password.dart';
import 'package:doctor/features/auth/presentation/widgets/signupWidgit.dart';
import 'package:doctor/features/auth/presentation/widgets/validator.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => LoginCubit(LoginService()),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logging in...')));
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));

              // ✅ Save token + username securely
              final cubit = context.read<LoginCubit>();
              final data = cubit.lastUserData;
              if (data != null) {
                await secureStorage.write(
                  key: 'token',
                  value: data['token'] ?? '',
                );
                await secureStorage.write(
                  key: 'email',
                  value: emailController.text,
                );
                await secureStorage.write(
                  key: 'username',
                  value: data['user']?['first_name'] ?? 'User',
                );
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColor.darkblue, AppColor.lightblue],
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.30,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 30,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "Welcome, Use Your Email To Sign On",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 57, 57, 57),
                                fontFamily: 'Serif',
                              ),
                            ),
                            const SizedBox(height: 14),
                            buildTextField(
                              emailController,
                              "Example@email.com",
                              IconMail.iconmail,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 15),
                            PasswordInput(controller: passwordController),

                            const SizedBox(height: 70),
                            GestureDetector(
                              onTap:
                                  state.isLoading
                                      ? null
                                      : () => _login(context),
                              child: Container(
                                width: 240,
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.darkblue,
                                      AppColor.lightblue,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.isLoading ? "Logging in..." : "Login",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                            const Padding(
                              padding: EdgeInsets.only(right: 140.0),
                              child: Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Serif',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF1F1F1),
                                side: const BorderSide(color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 100,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Center(child: Iconsteeth.teeth),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final model = LoginModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      context.read<LoginCubit>().loginUser(model);
    }
  }
}
