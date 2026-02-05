import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/doctor_detect_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/features/home/data/models/doctor_panorama_model.dart';
import 'package:doctor/features/home/data/sources/teeth_detect_service.dart';
import 'package:doctor/features/home/presentation/pages/exact_dental_chart.dart';

class DoctorResultsPage extends StatefulWidget {
  const DoctorResultsPage({super.key});

  @override
  State<DoctorResultsPage> createState() => _DoctorResultsPageState();
}

class _DoctorResultsPageState extends State<DoctorResultsPage> {
  final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  List<DoctorPanorama> panoramas = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return;

    final service = DioService();
    final data = await service.getDoctorPanoramas(token);

    setState(() {
      panoramas = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Results")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: panoramas.length,
        itemBuilder: (context, index) {
          final item = panoramas[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 Panorama Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.photo,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 👤 Customer
                  Text(
                    item.customerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 📅 Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Updated: ${item.updatedAt}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Created: ${item.createdAt}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔘 SHOW RESULT BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DentalChartPage(
                                  result: DoctorDetectResult(
                                    panoramaId: item.id,
                                    photo: item.photo,
                                    customerName: item.customerName,
                                    teethCount: item.teeth.length,
                                    teeth: item.teeth,
                                  ),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "Show Result",
                        style: TextStyle(color: AppColor.darkblue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
