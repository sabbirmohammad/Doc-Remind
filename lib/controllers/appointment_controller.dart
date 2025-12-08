import 'package:get/get.dart';
import 'package:doc_remind/models/appointment_model.dart';
import 'package:doc_remind/services/database_service.dart';
import 'package:doc_remind/services/notification_service.dart';

class AppointmentController extends GetxController {
  final appointments = RxList<AppointmentModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  void loadAppointments() {
    try {
      isLoading.value = true;
      final allAppointments = DatabaseService.getAllAppointments();
      appointments.assignAll(allAppointments);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load appointments: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAppointment({
    required String doctorName,
    required String specialty,
    required String clinic,
    required String phone,
    required DateTime appointmentDate,
    required String notes,
  }) async {
    try {
      isLoading.value = true;

      if (doctorName.isEmpty || specialty.isEmpty || clinic.isEmpty) {
        Get.snackbar('Error', 'Please fill all required fields');
        return false;
      }

      // Check for duplicate appointment (same doctor and same day/time)
      final duplicate = appointments.firstWhereOrNull(
        (a) =>
            a.doctorName.toLowerCase() == doctorName.toLowerCase().trim() &&
            a.appointmentDate.year == appointmentDate.year &&
            a.appointmentDate.month == appointmentDate.month &&
            a.appointmentDate.day == appointmentDate.day &&
            a.appointmentDate.hour == appointmentDate.hour &&
            a.appointmentDate.minute == appointmentDate.minute,
      );
      if (duplicate != null) {
        Get.snackbar(
          'Duplicate Appointment',
          'An appointment with Dr. $doctorName at this time already exists.',
          duration: const Duration(seconds: 4),
        );
        return false;
      }

      final appointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorName: doctorName,
        specialty: specialty,
        clinic: clinic,
        phone: phone,
        appointmentDate: appointmentDate,
        notes: notes,
      );

      await DatabaseService.addAppointment(appointment);
      appointments.add(appointment);

      // Schedule notification
      await _scheduleNotification(appointment);

      Get.snackbar('Success', 'Appointment added successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add appointment: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAppointment({
    required String id,
    required String doctorName,
    required String specialty,
    required String clinic,
    required String phone,
    required DateTime appointmentDate,
    required String notes,
    bool? attended,
  }) async {
    try {
      isLoading.value = true;

      final appointment = AppointmentModel(
        id: id,
        doctorName: doctorName,
        specialty: specialty,
        clinic: clinic,
        phone: phone,
        appointmentDate: appointmentDate,
        notes: notes,
        attended: attended ?? false,
      );

      await DatabaseService.updateAppointment(appointment);

      final index = appointments.indexWhere((a) => a.id == id);
      if (index != -1) {
        appointments[index] = appointment;
      }

      Get.snackbar('Success', 'Appointment updated successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      isLoading.value = true;
      await DatabaseService.deleteAppointment(id);
      appointments.removeWhere((a) => a.id == id);
      await NotificationService.cancelNotification(id.hashCode);
      Get.snackbar('Success', 'Appointment deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete appointment: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAttended(String id) async {
    try {
      final appointment = DatabaseService.getAppointment(id);
      if (appointment != null) {
        final updated = appointment.copyWith(attended: true);
        await DatabaseService.updateAppointment(updated);
        loadAppointments();
        Get.snackbar('Success', 'Appointment marked as attended');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update: ${e.toString()}');
    }
  }

  List<AppointmentModel> getUpcomingAppointments() {
    final now = DateTime.now();
    final upcoming = appointments
        .where((a) => a.appointmentDate.isAfter(now) && !a.attended)
        .toList();
    upcoming.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    return upcoming;
  }

  AppointmentModel? getNextAppointment() {
    final upcoming = getUpcomingAppointments();
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  int getTotalMissedAppointments() {
    final now = DateTime.now();
    return appointments
        .where((a) => a.appointmentDate.isBefore(now) && !a.attended)
        .length;
  }

  Future<void> _scheduleNotification(AppointmentModel appointment) async {
    final notificationId = appointment.id.hashCode;

    await NotificationService.scheduleAppointmentReminder(
      id: notificationId,
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      appointmentTime: appointment.appointmentDate,
    );
  }
}
