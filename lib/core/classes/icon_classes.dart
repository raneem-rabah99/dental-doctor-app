import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class Iconstooth {
  static Image tooth = Image.asset('assets/icons/tooth-whitening.png');
}

class Iconsteeth {
  static Image teeth = Image.asset(
    'assets/icons/logosenior.png',
    width: 170,
    height: 170,
    color: Colors.white,
  );
}

class IconKey {
  static Image iconkey = Image.asset(
    'assets/icons/IconKey.png',
    color: AppColor.darkblue,
    width: 5,
    height: 5,
  );
}

class Iconeye {
  static Image eye = Image.asset(
    'assets/icons/eye.png',
    width: 24,
    height: 24,
    color: AppColor.darkblue,
  );
}

class Icondental {
  static Image dentalshow = Image.asset(
    'assets/icons/dental.png',
    width: 100,
    height: 100,
  );
}

class Iconupload {
  static Image dental = Image.asset(
    'assets/icons/dental-x-ray (1).png',
    width: 100,
    height: 100,
  );
}

class IconMail {
  static Image iconmail = Image.asset(
    'assets/icons/mail-01.png',
    color: AppColor.darkblue,
    width: 24,
    height: 24,
  );
}

class Iconarrowleft {
  static Widget arrow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      'assets/icons/left-arrow.png',
      width: 20,
      height: 20,
      color: isDark ? Colors.white : Colors.black,
    );
  }
}

class Iconarowright {
  static Widget arrow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      'assets/icons/right-arrow.png',
      width: 20,
      height: 20,
      color: isDark ? Colors.white : Colors.black,
    );
  }
}

class Iconarowdel {
  static Image del = Image.asset('assets/icons/del.png', width: 35, height: 35);
}

class IconCamera {
  static Image camera = Image.asset(
    'assets/icons/camera-01.png',
    width: 20,
    height: 20,
  );
}

class Iconlocation {
  static Image location = Image.asset(
    'assets/icons/marker-pin-04.png',
    width: 24,
    height: 24,
    color: Color(0xffD2D2D2),
  );
}

class Iconclock {
  static Image clock = Image.asset(
    'assets/icons/clock.png',
    width: 10,
    height: 10,
  );
}

class Icontoday {
  static Image today = Image.asset(
    'assets/icons/today.png',
    width: 10,
    height: 10,
  );
}

class Iconedit {
  static Image edit = Image.asset(
    'assets/icons/edit.png',
    width: 20,
    height: 20,
    color: Color(0xff000000),
  );
}

class Iconedelete {
  static Image delete = Image.asset(
    'assets/icons/deleted.png',
    width: 20,
    height: 20,
    color: Color.fromARGB(255, 255, 0, 0),
  );
}

class Addcircleoutline {
  static Image addcircl = Image.asset(
    'assets/icons/addcircleoutline.png',
    width: 55,
    height: 55,
    color: Color.fromARGB(255, 255, 255, 255),
  );
}

class Iconecelender {
  static Image celender = Image.asset(
    'assets/icons/celender.png',
    width: 10,
    height: 10,
    color: Color(0xff000000),
  );
}

class IconDown {
  static Widget chevronDown = Center(
    child: Image.asset(
      'assets/icons/chevron-down.png',
      width: 30,
      height: 30,
      color: AppColor.darkblue,
    ),
  );
}

class IconePhone {
  static Image phone = Image.asset(
    'assets/icons/phone.png',
    width: 24,
    height: 24,
  );
}

class IconePerson {
  static Image person = Image.asset(
    'assets/icons/user.png',
    width: 15,
    height: 15,
    color: AppColor.darkblue,
  );
}
