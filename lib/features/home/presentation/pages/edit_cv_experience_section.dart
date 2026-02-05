import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/core/localization/app_strings.dart';

import 'package:doctor/features/auth/data/models/customer_info_model.dart';
import 'package:doctor/features/auth/data/sources/customer_info_service.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_cubit.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_state.dart';
import 'package:doctor/features/auth/presentation/widgets/uploadphoto.dart';

/// =======================================================
/// PUBLIC WIDGET (USED INSIDE Edit Page)
/// =======================================================
class EditCvExperienceSection extends StatefulWidget {
  const EditCvExperienceSection({super.key});

  @override
  State<EditCvExperienceSection> createState() =>
      _EditCvExperienceSectionState();
}

class _EditCvExperienceSectionState extends State<EditCvExperienceSection> {
  final _formKey = GlobalKey<FormState>();

  /// CONTROLLERS
  final specializationController = TextEditingController();
  final previousWorksController = TextEditingController();
  final openTimeController = TextEditingController();
  final closeTimeController = TextEditingController();

  /// CV (cross-platform)
  File? cvFile; // mobile
  Uint8List? cvBytes; // web
  String? cvFileName;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return BlocProvider(
      create: (_) => DoctorProfileCubit(DoctorProfileService()),
      child: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          if (state.success != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.success!)));
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop(context) ? 600 : double.infinity,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// ================= CV =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          UploadDocumentWidget(
                            title: "CV",
                            placeholderText: "Upload PDF",
                            uploadType: UploadType.pdf,
                            onFilePicked: (file) async {
                              if (file == null) return;

                              setState(() {
                                cvFileName = file.name;
                              });

                              if (kIsWeb) {
                                // ✅ WEB
                                final bytes = await file.readAsBytes();
                                setState(() {
                                  cvBytes = bytes;
                                  cvFile = null;
                                });
                              } else {
                                // ✅ MOBILE / DESKTOP
                                if (file.path != null &&
                                    file.path!.isNotEmpty) {
                                  setState(() {
                                    cvFile = File(file.path!);
                                    cvBytes = null;
                                  });
                                } else {
                                  // fallback (VERY IMPORTANT)
                                  final bytes = await file.readAsBytes();
                                  setState(() {
                                    cvBytes = bytes;
                                    cvFile = null;
                                  });
                                }
                              }
                            },
                          ),

                          if (cvFileName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                cvFileName!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),

                    /// ================= FIELDS =================
                    _buildField(
                      strings.specialization,
                      specializationController,
                    ),
                    _buildField(
                      strings.writeExperience,
                      previousWorksController,
                    ),
                    _buildField(
                      strings.openTimeText,
                      openTimeController,
                      hint: "09:00",
                    ),
                    _buildField(
                      strings.closeTimeText,
                      closeTimeController,
                      hint: "17:00",
                    ),

                    const SizedBox(height: 24),

                    /// ================= SAVE =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkblue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          state.isLoading ? strings.saveEdit : strings.saveEdit,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ================= INPUT FIELD =================
  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    // 🔴 UPLOAD CHECK (FIX)
    if (cvFile == null && cvBytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please upload CV file")));
      return;
    }

    final model = DoctorProfileModel(
      cvFile: cvFile,
      cvBytes: cvBytes,
      cvFileName: cvFileName,
      specialization: specializationController.text.trim(),
      previousWorks: previousWorksController.text.trim(),
      openTime: openTimeController.text.trim(),
      closeTime: closeTimeController.text.trim(),
    );

    context.read<DoctorProfileCubit>().submitProfile(model);
  }
}
