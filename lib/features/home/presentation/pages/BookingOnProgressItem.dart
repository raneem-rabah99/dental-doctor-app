import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doctor/core/api/base_url.dart';

/// ===============================
/// PAGE
/// ===============================
class DetectTeethPage extends StatelessWidget {
  final int customerId;

  const DetectTeethPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetectTeethCubit()..fetchPanoramaAndTeeth(customerId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Panorama & Teeth")),
        body: BlocBuilder<DetectTeethCubit, DetectTeethState>(
          builder: (context, state) {
            if (state is DetectTeethLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DetectTeethError) {
              return Center(child: Text(state.message));
            }

            if (state is DetectTeethSuccess) {
              final panorama = state.data['panorama_photo']['photo'];
              final teeth = state.data['teeth'] as List;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// 🦷 Panorama
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        panorama,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🦷 Teeth List
                    ...teeth.map(
                      (tooth) => _ToothItem(
                        tooth: tooth,
                        onEdit:
                            () => _showEditDialog(context, tooth, customerId),
                        onDelete:
                            () => _showDeleteDialog(context, tooth, customerId),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// ===============================
  /// EDIT
  /// ===============================
  static void _showEditDialog(
    BuildContext context,
    Map<String, dynamic> tooth,
    int customerId,
  ) {
    final controller = TextEditingController(text: tooth['descripe'] ?? '');
    File? selectedImage;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Edit Tooth #${tooth['number']}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      selectedImage = File(file.path);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Change Photo (Optional)"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await context.read<DetectTeethCubit>().updateTooth(
                    toothId: tooth['id'],
                    descripe: controller.text,
                    photo: selectedImage,
                    customerId: customerId,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  /// ===============================
  /// DELETE
  /// ===============================
  static void _showDeleteDialog(
    BuildContext context,
    Map<String, dynamic> tooth,
    int customerId,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Tooth"),
            content: Text(
              "Are you sure you want to delete Tooth #${tooth['number']}?\nThis action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);

                  await context.read<DetectTeethCubit>().deleteTooth(
                    toothId: tooth['id'],
                    customerId: customerId,
                    context: context,
                  );
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }
}

/// ===============================
/// TOOTH ITEM
/// ===============================
class _ToothItem extends StatelessWidget {
  final Map<String, dynamic> tooth;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ToothItem({
    required this.tooth,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.network(
          tooth['photo_panorama_generated'],
          width: 55,
          fit: BoxFit.cover,
        ),
        title: Text("Tooth #${tooth['number']}"),
        subtitle: Text(tooth['descripe'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// STATES
/// ===============================
abstract class DetectTeethState {}

class DetectTeethLoading extends DetectTeethState {}

class DetectTeethSuccess extends DetectTeethState {
  final Map<String, dynamic> data;
  DetectTeethSuccess(this.data);
}

class DetectTeethError extends DetectTeethState {
  final String message;
  DetectTeethError(this.message);
}

/// ===============================
/// CUBIT
/// ===============================
class DetectTeethCubit extends Cubit<DetectTeethState> {
  DetectTeethCubit() : super(DetectTeethLoading());

  Future<void> fetchPanoramaAndTeeth(int customerId) async {
    try {
      final res = await DetectTeethService.fetchPanoramaAndTeeth(customerId);
      emit(DetectTeethSuccess(res.data['data']));
    } catch (e) {
      emit(DetectTeethError(e.toString()));
    }
  }

  Future<void> deleteTooth({
    required int toothId,
    required int customerId,
    required BuildContext context,
  }) async {
    try {
      final success = await DetectTeethService.deleteTooth(toothId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tooth deleted successfully")),
        );
        await fetchPanoramaAndTeeth(customerId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Delete failed (server rejected)")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> updateTooth({
    required int toothId,
    required String descripe,
    File? photo,
    required int customerId,
  }) async {
    await DetectTeethService.updateTooth(
      toothId: toothId,
      descripe: descripe,
      photo: photo,
    );
    await fetchPanoramaAndTeeth(customerId);
  }
}

/// ===============================
/// SERVICE
/// ===============================
class DetectTeethService {
  static Future<Response> fetchPanoramaAndTeeth(int customerId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    return ApiClient.dio.post(
      '/doctor/panorama-teeth',
      data: {'customer_id': customerId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// ✅ DELETE (BACKEND-SAFE)
  static Future<bool> deleteTooth(int toothId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final formData = FormData.fromMap({
      'id': toothId, // for some controllers
      'tooth_id': toothId, // for others
    });

    final response = await ApiClient.dio.post(
      '/doctor/teeth/delete',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response.data != null && response.data['status'] == true;
  }

  static Future<void> updateTooth({
    required int toothId,
    required String descripe,
    File? photo,
  }) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final formData = FormData.fromMap({
      'id': toothId,
      'descripe': descripe,
      if (photo != null) 'photo': await MultipartFile.fromFile(photo.path),
    });

    await ApiClient.dio.post(
      '/doctor/teeth/update',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
