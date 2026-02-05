import 'package:flutter/material.dart';

class DoctorResultCard extends StatelessWidget {
  final String beforeImage;
  final String afterImage;
  final String doctorName;
  final double rating;

  const DoctorResultCard({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.doctorName,
    required this.rating,
  });

  bool _isNetwork(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }

  @override
  Widget build(BuildContext context) {
    const Color lightBlue = Color.fromARGB(255, 196, 227, 252);
    const Color mainBlue = Color(0xFF3BA4FF);
    const Color textColor = Color(0xFF1A2B3B);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.03), width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== TOP SECTION =====
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: lightBlue),
            child: Row(
              children: [
                Expanded(
                  child: _TreatmentPhoto(
                    label: "Before",
                    image: beforeImage,
                    alignmentBadge: Alignment.topLeft,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TreatmentPhoto(
                    label: "After",
                    image: afterImage,
                    alignmentBadge: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),

          // ===== BOTTOM SECTION =====
          Container(
            color: mainBlue,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: _DoctorInfoPill(
              doctorName: doctorName,
              rating: rating,
              textColor: textColor,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentPhoto extends StatelessWidget {
  final String label;
  final String image;
  final Alignment alignmentBadge;

  const _TreatmentPhoto({
    required this.label,
    required this.image,
    required this.alignmentBadge,
  });

  bool _isNetwork(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider =
        _isNetwork(image) ? NetworkImage(image) : AssetImage(image);

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Photo (❗UI SAME, ONLY changed AssetImage → provider variable)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: provider, fit: BoxFit.cover),
            ),
          ),

          // Badge (UNCHANGED)
          Align(
            alignment: alignmentBadge,
            child: Transform.translate(
              offset:
                  alignmentBadge == Alignment.topLeft
                      ? const Offset(-5, -5)
                      : const Offset(8, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF3BA4FF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorInfoPill extends StatelessWidget {
  final String doctorName;
  final double rating;
  final Color textColor;
  final Color backgroundColor;

  const _DoctorInfoPill({
    required this.doctorName,
    required this.rating,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              doctorName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Color(0xFFFFC107),
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;

  const _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.lineTo(0, size.height * 0.4);

    path.quadraticBezierTo(
      size.width * 0.18,
      size.height * 1.1,
      size.width * 0.35,
      size.height * 0.6,
    );

    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.2,
      size.width * 0.75,
      size.height * 0.8,
    );

    path.quadraticBezierTo(
      size.width * 0.88,
      size.height * 1.1,
      size.width,
      size.height * 0.6,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
