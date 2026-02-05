import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/managers/account_cubit.dart';
import 'package:doctor/features/home/presentation/managers/language_cubit.dart';
import 'package:doctor/features/home/presentation/managers/logout_cubit.dart';
import 'package:doctor/features/home/presentation/managers/logout_state.dart';
import 'package:doctor/features/home/presentation/managers/rate_app_cubit.dart';
import 'package:doctor/features/home/presentation/managers/rate_app_state.dart';
import 'package:doctor/features/home/presentation/managers/theme_cubit.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return BlocListener<RateAppCubit, RateAppState>(
      listener: (context, state) {
        if (state.success != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.success!)));
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        // ✅ APP BAR (RTL + DARK MODE SAFE)
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,

              // ✅ LEFT side (English)
              leading:
                  isArabic
                      ? null
                      : IconButton(
                        icon: Iconarrowleft.arrow(context),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false,
                          );
                        },
                      ),

              // ✅ RIGHT side (Arabic)
              actions:
                  isArabic
                      ? [
                        IconButton(
                          icon: Iconarowright.arrow(context),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ]
                      : null,

              title: Text(
                strings.settings,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
            ),
          ),
        ),

        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: isDesktop ? 500 : double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _tile(
                          context,
                          child: _toggle(
                            context,
                            strings.darkMode,
                            context.watch<ThemeCubit>().state == ThemeMode.dark,
                            (_) => context.read<ThemeCubit>().toggleTheme(),
                          ),
                        ),
                        _tile(
                          context,
                          child: _toggle(
                            context,
                            strings.language,
                            context.read<LanguageCubit>().state == "ar",
                            (_) => context.read<LanguageCubit>().toggleLang(),
                          ),
                        ),

                        _tile(
                          context,
                          child: _tileItem(
                            context,
                            strings.rateFeedback,
                            Icons.star,
                            () => _showRateFeedbackDialog(context, strings),
                          ),
                        ),
                        _tile(
                          context,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0, top: 16),
                            child: _redTile(
                              context,
                              strings.logout,
                              () => confirmLogout(context, strings),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- TILE CONTAINER ----------------
  Widget _tile(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: child,
    );
  }

  // ---------------- TOGGLE TILE ----------------
  Widget _toggle(
    BuildContext context,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.darkblue,
          ),
        ],
      ),
    );
  }

  // ---------------- NORMAL TILE ----------------
  Widget _tileItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(icon, color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  // ---------------- RED TILE ----------------
  Widget _redTile(BuildContext context, String title, VoidCallback onTap) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------- RATE DIALOG ----------------
  void _showRateFeedbackDialog(BuildContext context, AppStrings strings) {
    double rating = 0;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setState) {
            return AlertDialog(
              title: Text(strings.rateFeedback),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(strings.tapToRate),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => rating = i + 1.0),
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: strings.writeFeedback,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(strings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (rating == 0) return;
                    context.read<RateAppCubit>().rateApp(
                      rate: rating.toInt(),
                      feedback: controller.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(strings.send),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------- LOGOUT ----------------
void confirmLogout(BuildContext context, AppStrings strings) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocListener<LogoutCubit, LogoutState>(
        listener: (_, state) {
          if (state.success) {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
          }
        },
        child: AlertDialog(
          title: Text(strings.logout),
          content: Text(strings.confirmLogout),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () => context.read<LogoutCubit>().logout(),
              child: Text(
                strings.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    },
  );
}
