import 'package:flutter/material.dart';
import 'package:doctor/features/home/data/models/doctor_detect_result.dart';
import 'package:doctor/features/home/presentation/pages/exact_dental_chart.dart';

class TeethPage extends StatelessWidget {
  final DoctorDetectResult result;

  const TeethPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return DentalChartPage(result: result);
  }
}
