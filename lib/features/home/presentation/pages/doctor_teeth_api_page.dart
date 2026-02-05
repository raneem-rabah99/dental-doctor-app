import 'dart:io';
import 'package:doctor/features/home/data/sources/doctor_teeth_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_teeth_cubit.dart';
import 'package:doctor/features/home/presentation/managers/doctor_teeth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class DoctorTeethApiPage extends StatefulWidget {
  const DoctorTeethApiPage({super.key});

  @override
  State<DoctorTeethApiPage> createState() => _DoctorTeethApiPageState();
}

class _DoctorTeethApiPageState extends State<DoctorTeethApiPage> {
  // CREATE
  final _pIdCtrl = TextEditingController();
  final _nameCtrl = TextEditingController(); // "3_8"
  final _numberCtrl = TextEditingController();
  final _createDescCtrl = TextEditingController();

  // UPDATE
  final _updateIdCtrl = TextEditingController();
  final _updateDescCtrl = TextEditingController();

  // DELETE
  final _deleteIdCtrl = TextEditingController();

  File? _createPhoto;
  File? _updatePhoto;

  final _picker = ImagePicker();

  Future<void> _pickCreatePhoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _createPhoto = File(x.path));
  }

  Future<void> _pickUpdatePhoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _updatePhoto = File(x.path));
  }

  @override
  void dispose() {
    _pIdCtrl.dispose();
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _createDescCtrl.dispose();
    _updateIdCtrl.dispose();
    _updateDescCtrl.dispose();
    _deleteIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorTeethCubit(DoctorTeethService()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Doctor Teeth APIs")),
        body: BlocConsumer<DoctorTeethCubit, DoctorTeethState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            } else if (state.message != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<DoctorTeethCubit>();

            return AbsorbPointer(
              absorbing: state.isLoading,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.isLoading)
                    const LinearProgressIndicator(minHeight: 3),

                  const SizedBox(height: 14),

                  _sectionTitle("1) Create Tooth Doctor"),
                  _field(_pIdCtrl, "p_id (int)", TextInputType.number),
                  _field(_nameCtrl, "name مثل: 3_8", TextInputType.text),
                  _field(_numberCtrl, "number (int)", TextInputType.number),
                  _field(
                    _createDescCtrl,
                    "describe/descripe",
                    TextInputType.text,
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickCreatePhoto,
                        icon: const Icon(Icons.image),
                        label: const Text("Pick Photo (optional)"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _createPhoto == null
                              ? "No photo selected"
                              : _createPhoto!.path
                                  .split(Platform.pathSeparator)
                                  .last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final pId = int.tryParse(_pIdCtrl.text.trim()) ?? 0;
                      final number = int.tryParse(_numberCtrl.text.trim()) ?? 0;

                      cubit.create(
                        pId: pId,
                        name: _nameCtrl.text.trim(),
                        number: number,
                        descripe: _createDescCtrl.text.trim(),
                        photo: _createPhoto,
                      );
                    },
                    child: const Text("CREATE"),
                  ),

                  const Divider(height: 36),

                  _sectionTitle("2) Update Descripe (+ optional photo)"),
                  _field(_updateIdCtrl, "id (int)", TextInputType.number),
                  _field(_updateDescCtrl, "descripe", TextInputType.text),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickUpdatePhoto,
                        icon: const Icon(Icons.image),
                        label: const Text("Pick Photo (optional)"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _updatePhoto == null
                              ? "No photo selected"
                              : _updatePhoto!.path
                                  .split(Platform.pathSeparator)
                                  .last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final id = int.tryParse(_updateIdCtrl.text.trim()) ?? 0;
                      cubit.updateDescripe(
                        id: id,
                        descripe: _updateDescCtrl.text.trim(),
                        photo: _updatePhoto,
                      );
                    },
                    child: const Text("UPDATE"),
                  ),

                  const Divider(height: 36),

                  _sectionTitle("3) Delete Tooth"),
                  _field(_deleteIdCtrl, "id (int)", TextInputType.number),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      final id = int.tryParse(_deleteIdCtrl.text.trim()) ?? 0;
                      cubit.delete(id: id);
                    },
                    child: const Text("DELETE"),
                  ),

                  const SizedBox(height: 22),

                  // Show result data (created/updated)
                  if (state.created != null) ...[
                    _sectionTitle("✅ Created Result"),
                    _resultCard(state.created!),
                  ],
                  if (state.updated != null) ...[
                    _sectionTitle("✅ Updated Result"),
                    _resultCard(state.updated!),
                  ],
                  if (state.deletedId != null) ...[
                    _sectionTitle("✅ Deleted"),
                    Text("Deleted tooth id = ${state.deletedId}"),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _resultCard(dynamic tooth) {
    // tooth is DoctorTooth
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("id: ${tooth.id}"),
            Text("p_id: ${tooth.pId}"),
            Text("name: ${tooth.name}"),
            Text("number: ${tooth.number}"),
            Text("descripe: ${tooth.descripe}"),
            const SizedBox(height: 8),
            if (tooth.photoPanoramaGenerated != null &&
                (tooth.photoPanoramaGenerated as String).isNotEmpty)
              SelectableText("photo: ${tooth.photoPanoramaGenerated}"),
          ],
        ),
      ),
    );
  }
}
