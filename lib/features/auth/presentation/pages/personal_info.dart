import 'dart:io';
import 'dart:typed_data';

import 'package:doctor/features/auth/data/models/customer_info_model.dart';
import 'package:doctor/features/auth/data/sources/customer_info_service.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_cubit.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/auth/presentation/widgets/uploadphoto.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

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
    return BlocProvider(
      create: (_) => DoctorProfileCubit(DoctorProfileService()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Doctor Profile")),
        body: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
          listener: (context, state) {
            if (state.success != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.success!)));
            }
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop(context) ? 600 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        /// ================= CV Upload =================
                        UploadDocumentWidget(
                          title: "CV",
                          placeholderText: "Upload PDF",
                          uploadType: UploadType.pdf,
                          onFilePicked: (file) async {
                            if (file == null) return;

                            if (kIsWeb) {
                              final bytes = await file.readAsBytes();
                              setState(() {
                                cvBytes = bytes;
                                cvFileName = file.name;
                                cvFile = null;
                              });
                            } else {
                              if (file.path != null && file.path!.isNotEmpty) {
                                setState(() {
                                  cvFile = File(file.path!);
                                  cvFileName = file.name;
                                  cvBytes = null;
                                });
                              } else {
                                final bytes = await file.readAsBytes();
                                setState(() {
                                  cvBytes = bytes;
                                  cvFileName = file.name;
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

                        const SizedBox(height: 15),

                        _buildField("Specialization", specializationController),
                        _buildField("Previous Works", previousWorksController),
                        _buildField(
                          "Open Time",
                          openTimeController,
                          hint: "09:00",
                        ),
                        _buildField(
                          "Close Time",
                          closeTimeController,
                          hint: "17:00",
                        ),

                        const SizedBox(height: 30),

                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.darkblue, AppColor.lightblue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ElevatedButton(
                            onPressed:
                                state.isLoading ? null : () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              state.isLoading ? "Saving..." : "Save",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // INPUT FIELD
  // ───────────────────────────────────────────
  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // SUBMIT
  // ───────────────────────────────────────────
  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final model = DoctorProfileModel(
      cvFile: cvFile,
      cvBytes: cvBytes,
      cvFileName: cvFileName,
      specialization: specializationController.text,
      previousWorks: previousWorksController.text,
      openTime: openTimeController.text,
      closeTime: closeTimeController.text,
    );

    context.read<DoctorProfileCubit>().submitProfile(model);
  }
}
