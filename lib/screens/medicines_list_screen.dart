import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doc_remind/controllers/medicine_controller.dart';
import 'package:doc_remind/models/medicine_model.dart';
import 'package:intl/intl.dart';

class MedicinesListScreen extends StatefulWidget {
  const MedicinesListScreen({Key? key}) : super(key: key);

  @override
  State<MedicinesListScreen> createState() => _MedicinesListScreenState();
}

class _MedicinesListScreenState extends State<MedicinesListScreen> {
  final medicineController = Get.find<MedicineController>();
  String filterOption = 'All'; // All, Active, Inactive

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Obx(
                () => Text(
                  '${medicineController.medicines.length} medicines',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => medicineController.medicines.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services_rounded,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No medicines added yet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first medicine to get started',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/add-medicine'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Medicine'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: medicineController.medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicineController.medicines[index];
                  return _buildMedicineCard(context, medicine);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-medicine'),
        tooltip: 'Add Medicine',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, MedicineModel medicine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(Icons.medication, color: Theme.of(context).primaryColor),
        title: Text(
          medicine.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${medicine.dosage} • ${medicine.daysOfWeek.join(', ')}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medicine Details
                _buildDetailRow('Dosage', medicine.dosage),
                const SizedBox(height: 12),
                _buildDetailRow('Description', medicine.description),
                const SizedBox(height: 12),
                _buildDetailRow('Times', medicine.times.join(', ')),
                const SizedBox(height: 12),
                _buildDetailRow('Days', medicine.daysOfWeek.join(', ')),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Start Date',
                  DateFormat('dd MMM yyyy').format(medicine.startDate),
                ),
                if (medicine.endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildDetailRow(
                      'End Date',
                      DateFormat('dd MMM yyyy').format(medicine.endDate!),
                    ),
                  ),
                if (medicine.quantity != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildDetailRow(
                      'Quantity',
                      '${medicine.quantity} pills',
                    ),
                  ),
                if (medicine.missedDates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildDetailRow(
                      'Missed Doses',
                      '${medicine.missedDates.length} times',
                    ),
                  ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showEditDialog(context, medicine),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showDeleteDialog(context, medicine),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, MedicineModel medicine) {
    final nameController = TextEditingController(text: medicine.name);
    final dosageController = TextEditingController(text: medicine.dosage);
    final descriptionController = TextEditingController(
      text: medicine.description,
    );
    final quantityController = TextEditingController(
      text: medicine.quantity?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Medicine'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage',
                  hintText: 'e.g., 500mg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity (pills)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              medicineController.updateMedicine(
                id: medicine.id,
                name: nameController.text.trim(),
                dosage: dosageController.text.trim(),
                description: descriptionController.text.trim(),
                times: medicine.times,
                daysOfWeek: medicine.daysOfWeek,
                startDate: medicine.startDate,
                endDate: medicine.endDate,
                quantity: quantityController.text.isNotEmpty
                    ? int.parse(quantityController.text)
                    : null,
              );
              Navigator.pop(context);
              Get.snackbar('Success', 'Medicine updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MedicineModel medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
          'Are you sure you want to delete "${medicine.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              medicineController.deleteMedicine(medicine.id);
              Navigator.pop(context);
              Get.snackbar('Success', 'Medicine deleted successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
