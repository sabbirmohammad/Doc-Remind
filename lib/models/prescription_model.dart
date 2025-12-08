import 'package:hive/hive.dart';

part 'prescription_model.g.dart';

@HiveType(typeId: 2)
class PrescriptionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String doctorName;

  @HiveField(3)
  final DateTime uploadDate;

  @HiveField(4)
  final String notes;

  @HiveField(5)
  final bool processed;

  PrescriptionModel({
    required this.id,
    required this.imagePath,
    required this.doctorName,
    required this.uploadDate,
    required this.notes,
    this.processed = false,
  });

  PrescriptionModel copyWith({
    String? id,
    String? imagePath,
    String? doctorName,
    DateTime? uploadDate,
    String? notes,
    bool? processed,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      doctorName: doctorName ?? this.doctorName,
      uploadDate: uploadDate ?? this.uploadDate,
      notes: notes ?? this.notes,
      processed: processed ?? this.processed,
    );
  }
}
