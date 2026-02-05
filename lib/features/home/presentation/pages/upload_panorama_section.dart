import 'dart:io';

import 'package:doctor/core/classes/icon_classes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class UploadPanoramaSectionDoctor extends StatefulWidget {
  final Function(File file) onFileSelected;

  const UploadPanoramaSectionDoctor({super.key, required this.onFileSelected});

  @override
  State<UploadPanoramaSectionDoctor> createState() =>
      _UploadPanoramaSectionDoctorState();
}

class _UploadPanoramaSectionDoctorState
    extends State<UploadPanoramaSectionDoctor> {
  File? _file;
  bool _isImage = false;

  /// 🔹 show picker
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Upload Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Upload File'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAnyFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 📷 image (for preview)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        _file = file;
        _isImage = true;
      });

      widget.onFileSelected(file);
    }
  }

  /// 📄 any file (any extension)
  Future<void> _pickAnyFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // 👈 ANY FILE
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      setState(() {
        _file = file;
        _isImage = false;
      });

      widget.onFileSelected(file);
    }
  }

  bool _isImageFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp'].contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _showPickerOptions,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_file == null) ...[
                  Iconupload.dental,
                  const SizedBox(height: 8),
                  Text(
                    'Upload Panorama',
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose File',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ] else ...[
                  if (_isImage || _isImageFile(_file!.path))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _file!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Icon(
                      Icons.insert_drive_file,
                      size: 64,
                      color: Colors.blueGrey,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _file!.path.split('/').last,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
