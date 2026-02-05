import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/features/home/data/sources/doctor_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_cubit.dart';
import 'package:doctor/features/home/presentation/pages/booking_onprogress%20.dart';
import 'package:doctor/features/home/presentation/pages/doctor_teeth_api_page.dart';
import 'package:doctor/features/home/presentation/pages/patient_list_page.dart';
import 'package:doctor/features/home/presentation/pages/teeth_result_customer.dart';
import 'package:flutter/material.dart';
import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/booking_cancel.dart';
import 'package:doctor/features/home/presentation/pages/booking_done.dart';
import 'package:doctor/features/home/presentation/pages/booking_waiting.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      // ✅ ALLOW THEME TO CONTROL BACKGROUND (DARK MODE FIX)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        // ✅ ALLOW THEME TO CONTROL APPBAR BACKGROUND
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        // ✅ BACK ICON (POSITION FIX ONLY)
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
        actions:
            isArabic
                ? [
                  IconButton(
                    icon: Iconarowright.arrow(context),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                  ),
                ]
                : null,

        title: Text(
          strings.booking,
          style: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF234E9D),
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // ⭐ customer preview card (UNCHANGED)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.darkblue, AppColor.lightblue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.20),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 600;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: isDesktop ? 85 : 65,
                        height: isDesktop ? 85 : 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.doctor),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.findpatient,
                              style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: isDesktop ? 22 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              strings.browseDoctors,
                              style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: isDesktop ? 14 : 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DoctorResultsPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColor.darkblue,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 24 : 16,
                            vertical: isDesktop ? 14 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          strings.show,
                          style: TextStyle(
                            fontFamily: 'Gabarito',
                            fontSize: isDesktop ? 16 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ⭐ TabBar (UNCHANGED COLORS)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                // ✅ DARK MODE SAFE
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  if (Theme.of(context).brightness == Brightness.light)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: TabBar(
                controller: _tabController,

                // ✅ SELECTED TAB TEXT
                labelColor: Colors.white,

                // ✅ UNSELECTED TAB TEXT (AUTO DARK/LIGHT)
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodySmall?.color,

                // ✅ TAB INDICATOR
                indicator: BoxDecoration(
                  color: AppColor.darkblue,
                  borderRadius: BorderRadius.circular(20),
                ),

                labelStyle: const TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: strings.onProgress),
                  Tab(text: strings.waiting),
                  Tab(text: strings.done),
                  Tab(text: strings.canceled),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BookingOnProgressSection(),
                BookingWaitingSection(),
                BookingDoneSection(),
                BookingCancelSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
