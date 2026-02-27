import 'package:flutter/material.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../../resource/app_strings.dart';

class StatusBadge extends StatelessWidget {
  final RequestStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String statusText;
    switch (status) {
      case RequestStatus.APPROVED:
        color = Colors.green;
        statusText = AppStrings.approved;
        break;
      case RequestStatus.REJECTED:
        color = Colors.red;
        statusText = AppStrings.rejected;
        break;
      case RequestStatus.PENDING:
        color = Colors.orange;
        statusText = AppStrings.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
