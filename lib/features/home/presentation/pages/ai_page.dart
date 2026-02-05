import 'dart:io';

import 'package:doctor/features/home/presentation/pages/ai_cpst.dart';
import 'package:doctor/features/home/presentation/pages/doctor_teeth_api_page.dart';
import 'package:doctor/features/home/presentation/pages/teeth_result_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';

import 'package:doctor/features/home/data/models/doctor_detect_result.dart';
import 'package:doctor/features/home/data/sources/teeth_detect_service.dart';

import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:doctor/features/home/presentation/pages/upload_panorama_section.dart';
import 'package:doctor/features/home/presentation/pages/exact_dental_chart.dart';

class AiPageDoctor extends StatefulWidget {
  const AiPageDoctor({super.key});

  @override
  State<AiPageDoctor> createState() => _AiPageDoctorState();
}

class _AiPageDoctorState extends State<AiPageDoctor> {
  File? selectedImage;
  bool isLoading = false;

  final _storage = const FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.darkblue,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.aiScanTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.aiScanDesc,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Image.asset(
                        'assets/images/medical-check.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📤 IMAGE PICKER
              UploadPanoramaSectionDoctor(
                onFileSelected: (File file) {
                  setState(() {
                    selectedImage = file;
                  });
                },
              ),

              const SizedBox(height: 40),

              // ================= SUBMIT BUTTON =================
              Padding(
                padding: const EdgeInsets.only(left: 410.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: isDesktop ? 200 : double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        onPressed: isLoading ? null : _submitImage,
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  strings.submit,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: isDesktop ? 200 : double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AiPage()),
                          );
                        },
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  'CBCT submit',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90), // space for FAB (mobile)
            ],
          ),
        ),
      ),

      // ================= SHOW RESULT (CIRCLE WITH TEXT) =================
    );
  }

  // ================= SUBMIT LOGIC =================
  Future<void> _submitImage() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload an image first")),
      );
      return;
    }

    final customerName = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Customer Name"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Enter customer name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _nameController.text.trim());
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (customerName == null || customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer name is required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception("Token not found");

      final service = DioService();

      final DoctorDetectResult result = await service.detectDoctorTeeth(
        selectedImage!,
        token,
        customerName,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DentalChartPage(result: result)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
