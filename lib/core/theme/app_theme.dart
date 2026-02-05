import 'package:flutter/material.dart';

class AppTheme {
  // 🌞 LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F9FB),

    primaryColor: const Color(0xFF234E9D),

    cardColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF234E9D)),
      titleTextStyle: TextStyle(
        color: Color(0xFF234E9D),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(const Color(0xFF234E9D)),
    ),
  );

  // 🌙 DARK THEME
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),

    primaryColor: const Color(0xFF4C8CFF),

    cardColor: const Color(0xFF1E1E1E),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
    ),
  );
}
