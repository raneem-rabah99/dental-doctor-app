import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class Textstyle {
  static TextStyle text12bold = TextStyle(
    color: AppColor.darkblue,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Gabarito',
  );

  static TextStyle text16boldGabarito = TextStyle(
    color: AppColor.color,
    fontSize: 16,
    fontFamily: 'Gabarito-SemiBold',
    fontWeight: FontWeight.bold,
  );

  static TextStyle text24extrabold = TextStyle(
    color: AppColor.color,
    fontSize: 24,
    fontFamily: 'Gabarito-SemiBold',
    fontWeight: FontWeight.bold,
  );

  static TextStyle text12c = TextStyle(color: AppColor.color, fontSize: 12);

  static TextStyle text32bold = TextStyle(color: AppColor.color, fontSize: 32);

  static TextStyle text16c = TextStyle(color: AppColor.color);

  static TextStyle textbold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColor.color,
  );
}
