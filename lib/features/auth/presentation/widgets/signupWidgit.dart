import 'package:doctor/features/auth/presentation/pages/login_page.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget buildHeaderTop(String title) {
  return Text(
    title,
    style: TextStyle(
      fontFamily: 'Serif',
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.left,
  );
}

Widget buildHeader(String title) {
  return Text(
    title,
    style: TextStyle(
      fontFamily: 'Serif',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.left,
  );
}

Widget buildDropdownField(String hintText) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(border: InputBorder.none),
      hint: Text(
        hintText,
        style: TextStyle(fontFamily: 'Serif', color: Colors.grey[600]),
      ),
      items: [],
      onChanged: (value) {},
    ),
  );
}

Widget buildLoginLink(BuildContext context) {
  return Center(
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          const TextSpan(text: ' Already have an account? '),
          TextSpan(
            text: 'Sign in',
            style: TextStyle(
              color: AppColor.darkblue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
              decorationStyle: TextDecorationStyle.solid,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
          ),
        ],
      ),
    ),
  );
}

Widget buildTextField(
  TextEditingController controller,
  String hintText,
  Widget icon, {
  bool isPassword = false,
  String? Function(String?)? validator,
}) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 420, // 👈 desktop limit only
      ),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black, // أو Colors.white حسب الخلفية
          fontSize: 14,
        ),
        cursorColor: AppColor.darkblue,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 77, 77, 77),
            fontSize: 10,
          ),
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.darkblue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColor.darkblue, width: 2),
          ),
        ),
        validator: validator,
      ),
    ),
  );
}

Widget buildBackground2([String? title]) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.darkblue, AppColor.lightblue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      if (title != null) // Only display the title if it's provided
        Positioned(
          top: 150, // Adjust the position as needed
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ],
  );
}

Widget buildButton100(String text, VoidCallback? onPressed) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 420, // 👈 desktop limit only
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 30,
          right: 30,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.darkblue, AppColor.lightblue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildButton80(String text, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 1, bottom: 30, left: 50, right: 40),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.darkblue, AppColor.lightblue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Now dynamic
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
