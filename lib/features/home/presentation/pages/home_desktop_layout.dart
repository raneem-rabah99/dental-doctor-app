import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:doctor/core/localization/app_strings.dart';

class HomeDesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> pages;
  final Function(int) onItemTap;

  const HomeDesktopLayout({
    super.key,
    required this.selectedIndex,
    required this.pages,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      body: Row(
        children: [
          _sidebar(context, strings),

          // =======================
          // MAIN CONTENT + CHAT
          // =======================
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: pages[selectedIndex],
                ),

                // ✅ DESKTOP CHAT BUTTON
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: _desktopChatButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SIDEBAR
  // =====================================================
  Widget _sidebar(BuildContext context, AppStrings strings) {
    return Container(
      width: 240,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "ByteDent",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          _item(
            context,
            Image.asset(
              "assets/icons/people.png",
              width: 40,
              height: 40,
              color:
                  selectedIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
            ),
            strings.editProfile,
            0,
          ),
          _item(
            context,
            Image.asset(
              "assets/icons/dental-appointment.png",
              width: 40,
              height: 40,
              color:
                  selectedIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
            ),
            strings.appointments,
            1,
          ),
          _item(
            context,
            Image.asset(
              'assets/icons/tooth (1).png',
              width: 40,
              height: 40,
              color:
                  selectedIndex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
            ),
            strings.home,
            2,
          ),
          _item(
            context,
            Image.asset(
              'assets/icons/treatment.png',
              width: 40,
              height: 40,
              color:
                  selectedIndex == 3
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
            ),
            strings.aiTitle,
            3,
          ),
          _item(
            context,
            Image.asset(
              'assets/icons/settings.png',
              width: 40,
              height: 40,
              color:
                  selectedIndex == 4
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
            ),
            strings.settings,
            4,
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, Widget icon, String text, int index) {
    final active = selectedIndex == index;

    return InkWell(
      onTap: () => onItemTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color:
            active
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      active
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // DESKTOP CHAT BUTTON
  // =====================================================
  Widget _desktopChatButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => ByteDentChatDialog(api: ByteDentChatMessageApi()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.darkblue, AppColor.lightblue],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkblue.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.chat_bubble_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "ByteDent Chat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
