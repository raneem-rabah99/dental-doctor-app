import 'package:flutter/material.dart';
import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/header_home_page.dart';
import 'package:doctor/features/home/presentation/pages/today_approved_Section.dart';
import 'package:doctor/features/home/presentation/pages/show_result.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1000;
    final bool isTablet = width >= 700 && width < 1000;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Header(),

          _heroSection(isDesktop),

          const SizedBox(height: 35),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _glassCard(
                          context,
                          const TodayApprovedSection(),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(child: _glassCard(context, const ShowResult())),
                    ],
                  );
                }

                if (isTablet) {
                  return Column(
                    children: [
                      _glassCard(context, const TodayApprovedSection()),
                      const SizedBox(height: 20),
                      _glassCard(context, const ShowResult()),
                    ],
                  );
                }

                return Column(
                  children: [
                    _glassCard(context, const TodayApprovedSection()),
                    const SizedBox(height: 20),
                    _glassCard(context, const ShowResult()),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // HERO SECTION (UNCHANGED)
  // ------------------------------------------------------------------------
  Widget _heroSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 45 : 20,
        vertical: isDesktop ? 35 : 25,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.lightblue, AppColor.darkblue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ByteDent",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 38 : 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Keep your smile healthy today!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.90),
                    fontSize: isDesktop ? 18 : 13,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: isDesktop ? 130 : 85,
            height: isDesktop ? 130 : 85,
            child: FittedBox(fit: BoxFit.contain, child: Iconsteeth.teeth),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // 🧊 GLASS CARD — DARK MODE SAFE (FIXED)
  // ------------------------------------------------------------------------
  Widget _glassCard(BuildContext context, Widget child) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // ✅ SAME GLASS STYLE — JUST DARK AWARE
        color:
            isDark
                ? Colors.black.withOpacity(0.55)
                : Colors.white.withOpacity(0.85),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
          ),
        ],

        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(.6),
          width: 1.3,
        ),
      ),
      child: Padding(padding: const EdgeInsets.all(18), child: child),
    );
  }
}
