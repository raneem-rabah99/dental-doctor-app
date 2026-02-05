import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<ui.Image> removeBlackFromImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final width = image.width;
  final height = image.height;

  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final buffer = byteData!.buffer.asUint8List();

  // REMOVE BLACK PIXELS (r=g=b<40)
  for (int i = 0; i < buffer.length; i += 4) {
    int r = buffer[i];
    int g = buffer[i + 1];
    int b = buffer[i + 2];

    if (r < 40 && g < 40 && b < 40) {
      buffer[i + 3] = 0; // alpha = transparent
    }
  }

  final completer = Completer<ui.Image>();

  ui.decodeImageFromPixels(buffer, width, height, ui.PixelFormat.rgba8888, (
    ui.Image img,
  ) {
    completer.complete(img);
  });

  return completer.future;
}
