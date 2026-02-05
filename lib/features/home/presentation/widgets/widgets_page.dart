import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';

Widget buildTextFieldEdit(
  TextEditingController controller,
  String hintText,
  IconData icon, {
  bool isPassword = false,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 900;

      return Center(
        // ⭐ Center the text field on desktop
        child: Container(
          width: isDesktop ? 400 : double.infinity, // ⭐ Smaller on desktop
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              controller: controller,
              cursorColor: AppColor.darkblue,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(icon, color: AppColor.gray),

                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.darkblue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.darkblue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.gray, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator:
                  (value) => value!.isEmpty ? 'Please enter $hintText' : null,
            ),
          ),
        ),
      );
    },
  );
}

Widget buildCenteredLabel(String text) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 900;

      return Container(
        width: isDesktop ? 400 : double.infinity,
        alignment: Alignment.centerLeft, // for mobile
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: isDesktop ? TextAlign.center : TextAlign.left,
        ),
      );
    },
  );
}

Widget buildCenteredFormField({required String label, required Widget field}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 900;

      return Center(
        child: Container(
          width:
              isDesktop ? 450 : double.infinity, // ⭐ centers BOTH label + field
          child: Column(
            crossAxisAlignment:
                isDesktop
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: isDesktop ? TextAlign.center : TextAlign.left,
              ),
              const SizedBox(height: 6),
              field,
            ],
          ),
        ),
      );
    },
  );
}

Widget buildButtonProfilewithonpressed(String text, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 16, left: 50, right: 30),
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.darkblue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Now dynamic
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.darkblue,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadowColor: Colors.blueAccent,
          elevation: 6,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
