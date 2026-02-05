import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/features/home/presentation/pages/teeth_result_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';

import 'package:doctor/features/home/data/models/doctor_detect_result.dart';
import 'package:doctor/features/home/data/models/doctor_tooth.dart';
import 'package:doctor/features/home/data/sources/teeth_detect_service.dart';
import 'package:doctor/features/home/presentation/pages/ai_page.dart';
import 'package:doctor/features/home/presentation/widgets/cleantoothimage.dart';
import 'package:doctor/features/home/presentation/widgets/rotating_tooth.dart';

class DentalChartPage extends StatefulWidget {
  final DoctorDetectResult result;

  const DentalChartPage({super.key, required this.result});

  @override
  State<DentalChartPage> createState() => _DentalChartPageState();
}

class _DentalChartPageState extends State<DentalChartPage> {
  final service = DioService();
  final storage = const FlutterSecureStorage();

  /// 🔹 للإنشاء فقط
  String createDisease = "Caries";

  // ================= OPTIONS =================
  final List<String> diseaseOptions = [
    "Caries",
    "Deep Caries",
    "Impacted",
    "Periapical Lesion",
    "Extracted tooth",
    "Treatment Completed",
  ];

  final Map<String, Color> diseaseColors = {
    "Caries": Colors.orange,
    "Deep Caries": Colors.red,
    "Impacted": Colors.purple,
    "Periapical Lesion": Colors.green,
    "Extracted tooth": Colors.white, // ✅ أبيض عند الحذف
    "Treatment Completed": Colors.blue,
  };

  Color getColor(String d) => diseaseColors[d] ?? Colors.grey;

  // ================= HELPERS =================
  DoctorTooth? getTooth(int flutterTooth) {
    for (final t in widget.result.teeth) {
      final p = t.name.split('_');
      final q = int.tryParse(p[0]);
      final n = int.tryParse(p[1]);
      if (q == null || n == null) continue;
      if ((q - 1) * 8 + n == flutterTooth) return t;
    }
    return null;
  }

  // ================= DIALOG =================
  void showToothDialog(int flutterTooth) async {
    final existingTooth = getTooth(flutterTooth);

    String selectedDisease = existingTooth?.descripe ?? createDisease;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: 540,
                  height: 320,
                  child: Row(
                    children: [
                      // LEFT
                      Expanded(
                        flex: 3,
                        child: RotatingTooth(
                          child: CleanToothImage(
                            path:
                                'assets/icons/icon_teeth/teeth_$flutterTooth.jpg',
                            size: 120,
                            isProblem: true,
                            overlayColor: getColor(selectedDisease),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // RIGHT
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedDisease,
                              items:
                                  diseaseOptions
                                      .map(
                                        (d) => DropdownMenuItem(
                                          value: d,
                                          child: Text(
                                            d,
                                            style: TextStyle(
                                              color: getColor(d),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setDialog(() {
                                    selectedDisease = v;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            Expanded(
                              child:
                                  existingTooth?.photo == null
                                      ? const Center(child: Text("No image"))
                                      : ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          existingTooth!
                                              .photo!, // ✅ أولاً الرابط
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.contain,
                                          filterQuality:
                                              FilterQuality
                                                  .high, // 🔥 مهم للوضوح
                                        ),
                                      ),
                            ),

                            const SizedBox(height: 12),

                            // ===== UPDATE / CREATE =====
                            ElevatedButton(
                              onPressed: () async {
                                final token = await storage.read(key: 'token');
                                if (token == null) return;

                                if (existingTooth != null) {
                                  // 🔹 UPDATE
                                  await service.updateToothDescripe(
                                    toothId: existingTooth.id,
                                    descripe: selectedDisease,
                                    token: token,
                                  );

                                  setState(() {
                                    existingTooth.descripe = selectedDisease;
                                  });
                                } else {
                                  // 🔹 CREATE
                                  final quadrant =
                                      ((flutterTooth - 1) ~/ 8) + 1;
                                  final toothNumber =
                                      ((flutterTooth - 1) % 8) + 1;

                                  final newTooth = await service
                                      .createToothDoctor(
                                        panoramaId: widget.result.panoramaId,
                                        name: "${quadrant}_$toothNumber",
                                        number: flutterTooth,
                                        descripe: selectedDisease,
                                        token: token,
                                      );

                                  setState(() {
                                    widget.result.teeth.add(newTooth);
                                  });
                                }

                                Navigator.pop(context);
                              },
                              child: Text(
                                existingTooth == null ? "Create" : "Update",
                              ),
                            ),

                            // ===== DELETE =====
                            if (existingTooth != null)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  final token = await storage.read(
                                    key: 'token',
                                  );
                                  if (token == null) return;

                                  await service.deleteTooth(
                                    toothId: existingTooth.id,
                                    token: token,
                                  );

                                  setState(() {
                                    widget.result.teeth.removeWhere(
                                      (t) => t.id == existingTooth.id,
                                    );
                                  });

                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final upper = List.generate(16, (i) => i + 1);
    final lower = List.generate(16, (i) => 32 - i);
    final strings = AppStrings.of(context);

    Widget numberRow(List<int> nums) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            nums
                .map(
                  (n) => SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkblue,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      );
    }

    Widget toothRow(List<int> teeth) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            teeth.map((n) {
              final t = getTooth(n);
              return SizedBox(
                width: 36,
                child: GestureDetector(
                  onTap: () => showToothDialog(n),
                  child: CleanToothImage(
                    path: 'assets/icons/icon_teeth/teeth_$n.jpg',
                    size: 70,
                    isProblem: t != null,
                    overlayColor: t == null ? null : getColor(t.descripe),
                  ),
                ),
              );
            }).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.aiTitle),
        leading: IconButton(
          icon: Iconarrowleft.arrow(context),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DoctorResultsPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              widget.result.customerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Image.network(
              widget.result.photo,
              height: 360,
              width: double.infinity,
              fit: BoxFit.contain, // ✅ بدون قص
              filterQuality: FilterQuality.high, // 🔥 وضوح أعلى
            ),

            const SizedBox(height: 20),

            numberRow(upper),
            const SizedBox(height: 4),
            toothRow(upper),

            const SizedBox(height: 20),

            toothRow(lower),
            const SizedBox(height: 4),
            numberRow(lower),
          ],
        ),
      ),
    );
  }
}
