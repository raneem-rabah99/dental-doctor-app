import 'package:flutter/material.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/doctor_display_case_model.dart';

class StatusCaseCard extends StatelessWidget {
  final DoctorDisplayCaseModel model;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final VoidCallback onEdit;

  const StatusCaseCard({
    super.key,
    required this.model,
    required this.onDelete,
    required this.onFavorite,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status ID: ${model.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: onEdit, child: const Text("Edit")),
            ],
          ),

          const SizedBox(height: 12),

          // ===== IMAGES =====
          Row(
            children: [
              _image(model.photoBefore),
              const SizedBox(width: 12),
              _image(model.photoAfter),
            ],
          ),

          const SizedBox(height: 16),

          // ===== ACTIONS =====
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onDelete,
                  child: const Text("Delete"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onFavorite,
                  child: const Text("Set as favorite"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _image(String url) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(url, height: 120, fit: BoxFit.cover),
      ),
    );
  }
}
