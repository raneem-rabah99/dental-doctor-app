import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'removebackground.dart';

class CleanToothImage extends StatelessWidget {
  final String path;
  final double size;
  final bool isProblem;
  final Color? overlayColor; // ✅ جديد

  const CleanToothImage({
    super.key,
    required this.path,
    required this.size,
    this.isProblem = false,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: removeBlackFromImage(path),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: size, height: size);
        }

        Widget tooth = RawImage(
          image: snapshot.data,
          width: size,
          height: size,
          fit: BoxFit.contain,
        );

        if (overlayColor != null) {
          tooth = ColorFiltered(
            colorFilter: ColorFilter.mode(
              overlayColor!.withOpacity(0.45),
              BlendMode.modulate,
            ),
            child: tooth,
          );
        } else if (isProblem) {
          tooth = ColorFiltered(
            colorFilter: const ColorFilter.mode(
              ui.Color.fromARGB(138, 255, 145, 145),
              BlendMode.modulate,
            ),
            child: tooth,
          );
        }

        return tooth;
      },
    );
  }
}
