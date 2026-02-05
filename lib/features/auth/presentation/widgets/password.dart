import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const PasswordInput({
    Key? key,
    required this.controller,
    this.hintText = "Password",
    this.validator,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool desktop = MediaQuery.of(context).size.width >= 900;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: desktop ? 420 : double.infinity, // ✅ FIX
        ),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.black, // أو Colors.white حسب الخلفية
            fontSize: 14,
          ),
          controller: widget.controller,
          obscureText: !isPasswordVisible,
          validator: widget.validator,
          decoration: InputDecoration(
            prefixIcon: IconKey.iconkey,
            suffixIcon: IconButton(
              icon: Iconeye.eye,
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 77, 77, 77),
              fontSize: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.darkblue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColor.darkblue, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
