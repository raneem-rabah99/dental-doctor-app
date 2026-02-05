import 'package:doctor/features/home/data/sources/booking_status_service.dart';
import 'package:doctor/features/home/data/sources/doctor_display_case_service.dart';
import 'package:doctor/features/home/data/sources/today_approved_service.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_cubit.dart';
import 'package:doctor/features/home/presentation/managers/doctor_display_case_cubit.dart';
import 'package:doctor/features/home/presentation/managers/today_approved_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor/core/theme/app_theme.dart';
import 'package:doctor/features/home/presentation/managers/theme_cubit.dart';
import 'package:doctor/features/home/presentation/managers/language_cubit.dart';
import 'package:doctor/features/home/presentation/managers/account_cubit.dart';
import 'package:doctor/features/home/presentation/managers/rate_app_cubit.dart';
import 'package:doctor/features/home/presentation/managers/logout_cubit.dart';
import 'package:doctor/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:doctor/features/home/presentation/managers/delete_photo_cubit.dart';

import 'package:doctor/features/home/data/sources/rate_app_service.dart';
import 'package:doctor/features/home/data/sources/logout_service.dart';
import 'package:doctor/features/home/data/sources/update_photo_service.dart';
import 'package:doctor/features/home/data/sources/delete_photo_service.dart';

import 'package:doctor/features/auth/presentation/pages/splash_screen.dart';
import 'package:doctor/features/auth/presentation/pages/login_page.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => AccountCubit()),
        BlocProvider(create: (_) => RateAppCubit(RateAppService())),
        BlocProvider(create: (_) => LogoutCubit(LogoutService())),
        BlocProvider(create: (_) => UpdatePhotoCubit(UpdatePhotoService())),
        BlocProvider(create: (_) => DeletePhotoCubit(DeletePhotoService())),
        BlocProvider(
          create: (_) => DoctorDisplayCaseCubit(DoctorDisplayCaseService()),
        ),
        BlocProvider(create: (_) => BookingStatusCubit(BookingStatusService())),
        BlocProvider(create: (_) => TodayApprovedCubit(TodayApprovedService())),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, String>(
          builder: (context, lang) {
            return Directionality(
              textDirection:
                  lang == "ar" ? TextDirection.rtl : TextDirection.ltr,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "ByteDent App",
                initialRoute: "/",

                // ✅ THEMES CONNECTED HERE (YOUR AppTheme FILE USED)
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,

                routes: {
                  "/": (context) => const SplashScreen(),
                  "/login": (context) => LoginPage(),
                  "/home": (context) => const HomePage(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
