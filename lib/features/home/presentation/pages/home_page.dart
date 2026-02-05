import 'package:flutter/material.dart';
import 'package:doctor/features/home/presentation/pages/responsive_layout.dart';
import 'package:doctor/features/home/presentation/pages/home_mobile_layout.dart';
import 'package:doctor/features/home/presentation/pages/home_desktop_layout.dart';
import 'package:doctor/features/home/presentation/pages/edit_page.dart';
import 'package:doctor/features/home/presentation/pages/booking_page.dart';
import 'package:doctor/features/home/presentation/pages/ai_page.dart';
import 'package:doctor/features/home/presentation/pages/setting_page.dart';
import 'package:doctor/features/home/presentation/pages/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 2;

  late final List<Widget> pages = [
    EditPage(),
    BookingPage(),
    HomeContent(),
    AiPageDoctor(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeMobileLayout(
        selectedIndex: selected,
        pages: pages,
        onItemTapped: (i) => setState(() => selected = i),
      ),
      desktop: HomeDesktopLayout(
        selectedIndex: selected,
        pages: pages,
        onItemTap: (i) => setState(() => selected = i),
      ),
    );
  }
}
