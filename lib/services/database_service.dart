import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:doc_remind/models/user_model.dart';
import 'package:doc_remind/models/medicine_model.dart';
import 'package:doc_remind/models/appointment_model.dart';
import 'package:doc_remind/models/prescription_model.dart';

class DatabaseService {
  static const String usersBox = 'users';
  static const String medicinesBox = 'medicines';
  static const String appointmentsBox = 'appointments';
  static const String prescriptionsBox = 'prescriptions';

  static Future<void> initDatabase() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(MedicineModelAdapter());
    Hive.registerAdapter(AppointmentModelAdapter());
    Hive.registerAdapter(PrescriptionModelAdapter());

    // Open boxes (UserModel stored in SharedPreferences via AuthController)
    await Hive.openBox<MedicineModel>(medicinesBox);
    await Hive.openBox<AppointmentModel>(appointmentsBox);
    await Hive.openBox<PrescriptionModel>(prescriptionsBox);
  }

  // User operations (stored in SharedPreferences)
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('currentUser', userJson);
  }

  static UserModel? getUser() {
    // Note: This is called after prefs initialization in AuthController
    // For immediate access, use from SharedPreferences directly
    return null;
  }

  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  // Medicine operations
  static Future<void> addMedicine(MedicineModel medicine) async {
    final box = Hive.box<MedicineModel>(medicinesBox);
    await box.put(medicine.id, medicine);
  }

  static Future<void> updateMedicine(MedicineModel medicine) async {
    final box = Hive.box<MedicineModel>(medicinesBox);
    await box.put(medicine.id, medicine);
  }

  static Future<void> deleteMedicine(String id) async {
    final box = Hive.box<MedicineModel>(medicinesBox);
    await box.delete(id);
  }

  static List<MedicineModel> getAllMedicines() {
    final box = Hive.box<MedicineModel>(medicinesBox);
    return box.values.toList();
  }

  static MedicineModel? getMedicine(String id) {
    final box = Hive.box<MedicineModel>(medicinesBox);
    return box.get(id);
  }

  // Appointment operations
  static Future<void> addAppointment(AppointmentModel appointment) async {
    final box = Hive.box<AppointmentModel>(appointmentsBox);
    await box.put(appointment.id, appointment);
  }

  static Future<void> updateAppointment(AppointmentModel appointment) async {
    final box = Hive.box<AppointmentModel>(appointmentsBox);
    await box.put(appointment.id, appointment);
  }

  static Future<void> deleteAppointment(String id) async {
    final box = Hive.box<AppointmentModel>(appointmentsBox);
    await box.delete(id);
  }

  static List<AppointmentModel> getAllAppointments() {
    final box = Hive.box<AppointmentModel>(appointmentsBox);
    return box.values.toList();
  }

  static AppointmentModel? getAppointment(String id) {
    final box = Hive.box<AppointmentModel>(appointmentsBox);
    return box.get(id);
  }

  // Prescription operations
  static Future<void> addPrescription(PrescriptionModel prescription) async {
    final box = Hive.box<PrescriptionModel>(prescriptionsBox);
    await box.put(prescription.id, prescription);
  }

  static Future<void> updatePrescription(PrescriptionModel prescription) async {
    final box = Hive.box<PrescriptionModel>(prescriptionsBox);
    await box.put(prescription.id, prescription);
  }

  static Future<void> deletePrescription(String id) async {
    final box = Hive.box<PrescriptionModel>(prescriptionsBox);
    await box.delete(id);
  }

  static List<PrescriptionModel> getAllPrescriptions() {
    final box = Hive.box<PrescriptionModel>(prescriptionsBox);
    return box.values.toList();
  }

  static PrescriptionModel? getPrescription(String id) {
    final box = Hive.box<PrescriptionModel>(prescriptionsBox);
    return box.get(id);
  }
}
