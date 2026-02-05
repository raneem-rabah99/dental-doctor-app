import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/chatbot.dart';

import 'package:flutter/material.dart';

class ByteDentChatFloatingButton extends StatelessWidget {
  final ByteDentChatMessageApi chatApi;

  const ByteDentChatFloatingButton({super.key, required this.chatApi});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 90, // فوق الـ BottomNavigation
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => ByteDentChatDialog(api: chatApi),
          );
        },
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColor.darkblue, AppColor.lightblue],
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
      ),
    );
  }
}
