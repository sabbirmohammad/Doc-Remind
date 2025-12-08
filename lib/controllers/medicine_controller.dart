import 'package:get/get.dart';
import 'package:doc_remind/models/medicine_model.dart';
import 'package:doc_remind/services/database_service.dart';
import 'package:doc_remind/services/notification_service.dart';

class MedicineController extends GetxController {
  final medicines = RxList<MedicineModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  void loadMedicines() {
    try {
      isLoading.value = true;
      final allMedicines = DatabaseService.getAllMedicines();
      medicines.assignAll(allMedicines);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medicines: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addMedicine({
    required String name,
    required String dosage,
    required String description,
    required List<String> times,
    required List<String> daysOfWeek,
    required DateTime startDate,
    DateTime? endDate,
    int? quantity,
  }) async {
    try {
      isLoading.value = true;

      if (name.isEmpty ||
          dosage.isEmpty ||
          times.isEmpty ||
          daysOfWeek.isEmpty) {
        Get.snackbar('Error', 'Please fill all required fields');
        return false;
      }

      // Check for duplicate medicine
      final duplicate = medicines.firstWhereOrNull(
        (m) => m.name.toLowerCase() == name.toLowerCase().trim(),
      );
      if (duplicate != null) {
        Get.snackbar(
          'Duplicate Medicine',
          'A medicine with the name "$name" already exists. Please use a different name.',
          duration: const Duration(seconds: 4),
        );
        return false;
      }

      final medicine = MedicineModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        dosage: dosage,
        description: description,
        times: times,
        daysOfWeek: daysOfWeek,
        startDate: startDate,
        endDate: endDate,
        quantity: quantity,
      );

      await DatabaseService.addMedicine(medicine);
      medicines.add(medicine);

      // Schedule notifications
      await _scheduleNotifications(medicine);

      Get.snackbar('Success', 'Medicine added successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add medicine: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateMedicine({
    required String id,
    required String name,
    required String dosage,
    required String description,
    required List<String> times,
    required List<String> daysOfWeek,
    required DateTime startDate,
    DateTime? endDate,
    int? quantity,
  }) async {
    try {
      isLoading.value = true;

      final medicine = MedicineModel(
        id: id,
        name: name,
        dosage: dosage,
        description: description,
        times: times,
        daysOfWeek: daysOfWeek,
        startDate: startDate,
        endDate: endDate,
        quantity: quantity,
      );

      await DatabaseService.updateMedicine(medicine);

      final index = medicines.indexWhere((m) => m.id == id);
      if (index != -1) {
        medicines[index] = medicine;
      }

      // Reschedule notifications
      await NotificationService.cancelNotification(medicine.id.hashCode);
      await _scheduleNotifications(medicine);

      Get.snackbar('Success', 'Medicine updated successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update medicine: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      isLoading.value = true;
      await DatabaseService.deleteMedicine(id);
      medicines.removeWhere((m) => m.id == id);
      await NotificationService.cancelNotification(id.hashCode);
      Get.snackbar('Success', 'Medicine deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete medicine: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markMedicineAsMissed(String medicineId, DateTime date) async {
    try {
      final medicine = DatabaseService.getMedicine(medicineId);
      if (medicine != null) {
        final dateStr = '${date.year}-${date.month}-${date.day}';
        if (!medicine.missedDates.contains(dateStr)) {
          final updatedMissedDates = [...medicine.missedDates, dateStr];
          final updatedMedicine = medicine.copyWith(
            missedDates: updatedMissedDates,
          );
          await DatabaseService.updateMedicine(updatedMedicine);
          loadMedicines();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to record missed dose: ${e.toString()}');
    }
  }

  List<MedicineModel> getMedicinesTodayByTime(String time) {
    final today = DateTime.now();
    final dayOfWeek = _getDayOfWeek(today.weekday);

    return medicines.where((medicine) {
      return medicine.daysOfWeek.contains(dayOfWeek) &&
          medicine.times.contains(time);
    }).toList();
  }

  int getMissedDosesCount() {
    int count = 0;
    for (var medicine in medicines) {
      count += medicine.missedDates.length;
    }
    return count;
  }

  Future<void> _scheduleNotifications(MedicineModel medicine) async {
    // Schedule notifications for each time
    for (var time in medicine.times) {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final notificationId = '${medicine.id}_${time}'.hashCode;

      await NotificationService.scheduleMedicineReminder(
        id: notificationId,
        medicineName: medicine.name,
        dosage: medicine.dosage,
        scheduledTime: scheduledDate,
      );
    }
  }

  String _getDayOfWeek(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
