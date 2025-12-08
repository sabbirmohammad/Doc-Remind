import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doc_remind/controllers/appointment_controller.dart';
import 'package:doc_remind/models/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  final appointmentController = Get.find<AppointmentController>();
  String filterOption = 'All'; // All, Upcoming, Past, Missed

  @override
  void initState() {
    super.initState();
    // Check if a filter was passed via navigation arguments
    final arguments = Get.arguments;
    if (arguments != null &&
        arguments is Map &&
        arguments.containsKey('filter')) {
      filterOption = arguments['filter'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Obx(
                () => Text(
                  '${appointmentController.appointments.length} appointments',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Upcoming'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Past'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Missed'),
                ],
              ),
            ),
          ),
          // Appointments List
          Expanded(
            child: Obx(() {
              final filteredAppointments = _getFilteredAppointments();

              if (filteredAppointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No appointments found',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return _buildAppointmentCard(appointment);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-appointment'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = filterOption == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            filterOption = label;
          });
        }
      },
    );
  }

  List<AppointmentModel> _getFilteredAppointments() {
    final now = DateTime.now();
    final allAppointments = appointmentController.appointments;

    switch (filterOption) {
      case 'Upcoming':
        return allAppointments
            .where((a) => a.appointmentDate.isAfter(now) && !a.attended)
            .toList()
          ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
      case 'Past':
        return allAppointments
            .where((a) => a.appointmentDate.isBefore(now) || a.attended)
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      case 'Missed':
        return allAppointments
            .where((a) => a.appointmentDate.isBefore(now) && !a.attended)
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      default:
        return allAppointments.toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
    }
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    final now = DateTime.now();
    final isPast = appointment.appointmentDate.isBefore(now);
    final isUpcoming = appointment.appointmentDate.isAfter(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: appointment.attended
              ? Colors.green
              : isPast
              ? Colors.red.shade300
              : Colors.blue,
          child: Icon(
            appointment.attended ? Icons.check : Icons.calendar_today,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          appointment.doctorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              appointment.specialty,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat(
                'MMMM d, yyyy - h:mm a',
              ).format(appointment.appointmentDate),
              style: TextStyle(
                color: isPast ? Colors.red.shade400 : Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Clinic', appointment.clinic),
                const SizedBox(height: 8),
                _buildDetailRow('Phone', appointment.phone),
                if (appointment.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow('Notes', appointment.notes),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isUpcoming && !appointment.attended)
                      TextButton.icon(
                        onPressed: () => _showEditDialog(appointment),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                      ),
                    if (!appointment.attended)
                      TextButton.icon(
                        onPressed: () => _markAsAttended(appointment.id),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Attended'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () => _deleteAppointment(appointment.id),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
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
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _markAsAttended(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Attended'),
        content: const Text('Mark this appointment as attended?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appointmentController.markAttended(id);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text(
          'Are you sure you want to delete this appointment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appointmentController.deleteAppointment(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(AppointmentModel appointment) {
    final doctorNameController = TextEditingController(
      text: appointment.doctorName,
    );
    final specialtyController = TextEditingController(
      text: appointment.specialty,
    );
    final clinicController = TextEditingController(text: appointment.clinic);
    final phoneController = TextEditingController(text: appointment.phone);
    final notesController = TextEditingController(text: appointment.notes);
    DateTime selectedDate = appointment.appointmentDate;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
      appointment.appointmentDate,
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: doctorNameController,
                  decoration: const InputDecoration(labelText: 'Doctor Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: specialtyController,
                  decoration: const InputDecoration(labelText: 'Specialty'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: clinicController,
                  decoration: const InputDecoration(labelText: 'Clinic'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(
                    DateFormat('MMMM d, yyyy').format(selectedDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                ListTile(
                  title: const Text('Time'),
                  subtitle: Text(selectedTime.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
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
                final appointmentDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                appointmentController.updateAppointment(
                  id: appointment.id,
                  doctorName: doctorNameController.text,
                  specialty: specialtyController.text,
                  clinic: clinicController.text,
                  phone: phoneController.text,
                  appointmentDate: appointmentDate,
                  notes: notesController.text,
                  attended: appointment.attended,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
