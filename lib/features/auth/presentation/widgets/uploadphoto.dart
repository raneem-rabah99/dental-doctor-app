import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

enum UploadType { image, pdf }

class UploadDocumentWidget extends StatefulWidget {
  final String title;
  final String placeholderText;
  final double height;
  final double width;
  final Function(XFile?)? onFilePicked;
  final IconData? icon;
  final UploadType uploadType;

  const UploadDocumentWidget({
    super.key,
    required this.title,
    required this.placeholderText,
    this.height = 100,
    this.width = double.infinity,
    this.onFilePicked,
    this.icon,
    this.uploadType = UploadType.image,
  });

  @override
  State<UploadDocumentWidget> createState() => _UploadDocumentWidgetState();
}

class _UploadDocumentWidgetState extends State<UploadDocumentWidget> {
  XFile? _file;

  Future<void> _pickFile() async {
    if (widget.uploadType == UploadType.image) {
      await _pickImage();
    } else {
      await _pickPdf();
    }
  }

  /// ================= IMAGE PICKER =================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _file = picked);
      widget.onFilePicked?.call(picked);
    }
  }

  /// ================= PDF PICKER =================
  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (result == null) return;

    final file = result.files.single;

    Uint8List bytes = file.bytes ?? Uint8List.fromList(<int>[]); // ✅ FIX

    final xFile = XFile.fromData(bytes, name: file.name, path: file.path);

    setState(() => _file = xFile);
    widget.onFilePicked?.call(xFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: DottedBorder(
              child: Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_file == null)
                      Icon(
                        widget.icon ??
                            (widget.uploadType == UploadType.pdf
                                ? Icons.picture_as_pdf
                                : Icons.image),
                        color: const Color(0xffA3A3A3),
                      ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _file == null ? widget.placeholderText : _file!.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xffA3A3A3),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
