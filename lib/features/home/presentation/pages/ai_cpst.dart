import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';

import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:doctor/features/home/presentation/pages/upload_panorama_section.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  /// ✅ ONE FILE (image or any file)
  File? selectedFile;

  final _storage = const FlutterSecureStorage();

  bool isProcessing = false;
  List<PredictionResult> results = [];

  bool get hasFile => selectedFile != null;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(strings.aiTitle, style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        leading:
            isArabic
                ? null
                : IconButton(
                  icon: Iconarrowleft.arrow(context),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (_) => false,
                    );
                  },
                ),
        actions:
            isArabic
                ? [
                  IconButton(
                    icon: Iconarowright.arrow(context),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (_) => false,
                      );
                    },
                  ),
                ]
                : null,
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ⭐ TOP CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.darkblue, AppColor.lightblue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  'AI CBCT Scan',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📤 FILE PICKER (IMAGE OR ANY FILE)
              UploadPanoramaSectionDoctor(
                onFileSelected: (File file) {
                  setState(() {
                    selectedFile = file;
                    results.clear();
                  });
                },
              ),

              const SizedBox(height: 40),

              // ================= SUBMIT BUTTON =================
              SizedBox(
                width: isDesktop ? 200 : double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasFile ? AppColor.darkblue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: hasFile && !isProcessing ? _submit : null,
                  child: const Text(
                    'CBCT submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ================= LOADING =================
              if (isProcessing) _loadingCard(),

              // ================= RESULT =================
              if (!isProcessing && results.isNotEmpty) _resultCard(),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SUBMIT WITH TOKEN =================
  Future<void> _submit() async {
    setState(() {
      isProcessing = true;
      results.clear();
    });

    try {
      final token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        throw Exception('Token not found');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/predict'),
      );

      // ✅ AUTH HEADER
      request.headers['Authorization'] = 'Bearer $token';

      // ✅ FILE (ANY TYPE)
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedFile!.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        final List list = jsonData['top_3_predictions'];

        setState(() {
          results = list.map((e) => PredictionResult.fromJson(e)).toList();
        });
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  // ================= LOADING CARD =================
  Widget _loadingCard() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Center(
        child: SizedBox(
          height: 26,
          width: 26,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColor.darkblue,
          ),
        ),
      ),
    );
  }

  // ================= RESULT CARD =================
  // ================= RESULT CARD =================
  Widget _resultCard() {
    return Column(
      children:
          results.map((r) {
            final percent = r.probability.clamp(0, 100);

            Color confidenceColor;
            if (percent >= 70) {
              confidenceColor = Colors.green;
            } else if (percent >= 40) {
              confidenceColor = Colors.orange;
            } else {
              confidenceColor = Colors.redAccent;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🦷 ICON
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          confidenceColor.withOpacity(0.9),
                          confidenceColor.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // 📄 CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NAME
                        Text(
                          r.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ICD
                        Text(
                          'ICD: ${r.icd}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // PROGRESS BAR
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percent / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              confidenceColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // PERCENT
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${percent.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: confidenceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// ================= MODEL =================
class PredictionResult {
  final String icd;
  final String name;
  final double probability;

  PredictionResult({
    required this.icd,
    required this.name,
    required this.probability,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      icd: json['icd'],
      name: json['name'],
      probability: (json['probability'] as num).toDouble(),
    );
  }
}
