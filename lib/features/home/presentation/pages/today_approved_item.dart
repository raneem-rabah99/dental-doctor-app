import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/features/home/data/models/today_approved_model.dart';
import 'package:flutter/material.dart';

class TodayApprovedItem extends StatelessWidget {
  final TodayApprovedModel caseItem;

  const TodayApprovedItem({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings.of(context);

    return Container(
      width: 200,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // ✅ shadow only in light mode
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TOP ROW ----------
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      caseItem.photo != null && caseItem.photo!.isNotEmpty
                          ? NetworkImage(caseItem.photo!)
                          : const AssetImage(AppAssets.user) as ImageProvider,
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${caseItem.firstName} ${caseItem.lastName}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _localizedStatus(caseItem.status, strings),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _statusColor(caseItem.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 3),

            // ---------- DATE & TIME ----------
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.iconTheme.color,
                ),
                const SizedBox(width: 6),
                Text(caseItem.date, style: theme.textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(Icons.access_time, size: 16, color: theme.iconTheme.color),
                const SizedBox(width: 6),
                Text(caseItem.time, style: theme.textTheme.bodySmall),
              ],
            ),

            if (caseItem.note.isNotEmpty) ...[
              const SizedBox(height: 3),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 3),

              // ---------- NOTE ----------
              Text(
                caseItem.note,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- STATUS COLOR (UNCHANGED) ----------
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  // ---------- STATUS TEXT (LOCALIZED) ----------
  String _localizedStatus(String status, AppStrings strings) {
    switch (status.toLowerCase()) {
      case 'approved':
        return strings.statusApproved();
      case 'pending':
        return strings.statusPending();
      case 'rejected':
        return strings.statusRejected();
      default:
        return status.toUpperCase();
    }
  }
}
