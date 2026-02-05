import 'package:doctor/features/home/presentation/pages/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/core/localization/app_strings.dart';

class HomeMobileLayout extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> pages;
  final Function(int) onItemTapped;

  const HomeMobileLayout({
    super.key,
    required this.selectedIndex,
    required this.pages,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // =================================================
      // BODY + CHAT BUTTON
      // =================================================
      body: Stack(
        children: [
          pages[selectedIndex],

          // ✅ CHAT BUTTON (Mobile)
          Positioned(
            right: 20,
            bottom: 90, // فوق الـ BottomNavigationBar
            child: _mobileChatButton(context),
          ),
        ],
      ),

      // =================================================
      // BOTTOM NAVIGATION
      // =================================================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: AppColor.darkblue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/user.png')),
            label: strings.editProfile,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage('assets/icons/dental-appointment.png'),
            ),
            label: strings.appointments,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/tooth (1).png')),
            label: strings.home,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/treatment.png')),
            label: strings.aiTitle,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/settings.png')),
            label: strings.settings,
          ),
        ],
      ),
    );
  }

  // =================================================
  // MOBILE CHAT BUTTON
  // =================================================
  Widget _mobileChatButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => ByteDentChatDialog(api: ByteDentChatMessageApi()),
        );
      },
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColor.darkblue, AppColor.lightblue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkblue.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
