import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingTooth extends StatefulWidget {
  final Widget child;

  const RotatingTooth({super.key, required this.child});

  @override
  State<RotatingTooth> createState() => _RotatingToothState();
}

class _RotatingToothState extends State<RotatingTooth>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 🐢 بطيء
    );

    _animation = Tween<double>(
      begin: math.pi, // ⬅️ خلف
      end: 0, // ➡️ أمام
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(); // 🔁 مستمر
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // ✨ عمق ثلاثي الأبعاد
                ..rotateY(_animation.value),
          child: child,
        );
      },
    );
  }
}
