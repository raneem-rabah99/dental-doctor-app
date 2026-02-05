import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/features/auth/presentation/pages/personal_info.dart';
import 'package:doctor/features/auth/presentation/widgets/password.dart';
import 'package:doctor/features/auth/presentation/widgets/signupWidgit.dart';
import 'package:doctor/features/auth/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class submitpage extends StatefulWidget {
  const submitpage({super.key});

  @override
  State<submitpage> createState() => _submitpageState();
}

class _submitpageState extends State<submitpage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground2(),

          Positioned(bottom: 0, left: 0, right: 0, child: buildFormContainer()),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // 🔹 Keep Existing White Header (No Changes)
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: const Text(
                      "Logo",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormContainer() {
    return Container(
      height: 550,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Email ',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // اللون الأساسي للنص
                      ),
                    ),
                    TextSpan(
                      text: '( Optional )',
                      style: TextStyle(
                        fontFamily: 'Serif',

                        color: Color(0xffA3A3A3), // اللون المطلوب لـ (Optional)
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),
              buildTextField(
                emailController,
                "Example@email.com",
                IconMail.iconmail,
                validator: Validators.validateEmail,
              ),

              SizedBox(height: 10),
              Text(
                "Password",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              PasswordInput(
                hintText: '*************',
                controller: passwordController,
                validator: Validators.validatePassword,
              ),
              buildButton100("Next", _next),
            ],
          ),
        ),
      ),
    );
  }

  void _next() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _secureStorage.write(
          key: "Example@email.com",
          value: emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please log in.'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorProfilePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }
}
