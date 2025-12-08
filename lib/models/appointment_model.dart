import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 1)
class AppointmentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String doctorName;

  @HiveField(2)
  final String specialty;

  @HiveField(3)
  final String clinic;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final DateTime appointmentDate;

  @HiveField(6)
  final String notes;

  @HiveField(7)
  final bool reminderSet;

  @HiveField(8)
  final bool attended;

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.clinic,
    required this.phone,
    required this.appointmentDate,
    required this.notes,
    this.reminderSet = true,
    this.attended = false,
  });

  AppointmentModel copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    String? clinic,
    String? phone,
    DateTime? appointmentDate,
    String? notes,
    bool? reminderSet,
    bool? attended,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      clinic: clinic ?? this.clinic,
      phone: phone ?? this.phone,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      notes: notes ?? this.notes,
      reminderSet: reminderSet ?? this.reminderSet,
      attended: attended ?? this.attended,
    );
  }
}
