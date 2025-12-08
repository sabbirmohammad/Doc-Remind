import 'package:flutter/material.dart';
import 'package:doc_remind/models/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medicine.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(medicine.dosage),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (medicine.description.isNotEmpty)
              Column(
                children: [
                  Text(
                    medicine.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            Row(
              children: [
                Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Times: ${medicine.times.join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Days: ${medicine.daysOfWeek.join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
