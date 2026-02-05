import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/ai_page.dart';
import 'package:doctor/features/home/presentation/pages/teeth_section.dart';
import 'package:flutter/material.dart';

class ShowResult extends StatelessWidget {
  const ShowResult({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Column(
      children: [
        const SizedBox(height: 2),

        /// Main Result Box (same UI as upload)
        Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 43, 121, 255).withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  188,
                  188,
                  188,
                ).withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icondental.dentalshow,
              const SizedBox(height: 12),

              Text(
                strings.showResultTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColor.darkblue,
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  strings.showResultDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 13,
                    height: 1.6,
                    color: AppColor.lightblue,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                strings.showResultHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              // ⭐ Navigation Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkblue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  shadowColor: Colors.blueAccent,
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiPageDoctor()),
                  );
                },
                child: Text(
                  strings.startAiTreatment,
                  style: const TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
