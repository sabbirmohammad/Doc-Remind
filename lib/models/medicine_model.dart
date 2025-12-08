import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 0)
class MedicineModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String dosage;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> times; // HH:mm format

  @HiveField(5)
  final List<String> daysOfWeek; // Mon, Tue, Wed, etc.

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime? endDate;

  @HiveField(8)
  final int? quantity;

  @HiveField(9)
  final List<String> missedDates; // Track missed doses

  MedicineModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.description,
    required this.times,
    required this.daysOfWeek,
    required this.startDate,
    this.endDate,
    this.quantity,
    this.missedDates = const [],
  });

  MedicineModel copyWith({
    String? id,
    String? name,
    String? dosage,
    String? description,
    List<String>? times,
    List<String>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
    int? quantity,
    List<String>? missedDates,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      description: description ?? this.description,
      times: times ?? this.times,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantity: quantity ?? this.quantity,
      missedDates: missedDates ?? this.missedDates,
    );
  }
}
