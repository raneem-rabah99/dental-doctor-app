import 'dart:io';
import 'dart:typed_data';

class DoctorProfileModel {
  final File? cvFile;
  final Uint8List? cvBytes;
  final String? cvFileName;

  final String specialization;
  final String previousWorks;
  final String openTime;
  final String closeTime;

  DoctorProfileModel({
    this.cvFile,
    this.cvBytes,
    this.cvFileName,
    required this.specialization,
    required this.previousWorks,
    required this.openTime,
    required this.closeTime,
  });
}
