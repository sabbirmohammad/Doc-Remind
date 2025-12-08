import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doc_remind/models/prescription_model.dart';
import 'package:doc_remind/services/database_service.dart';

class PrescriptionController extends GetxController {
  final prescriptions = RxList<PrescriptionModel>();
  final isLoading = false.obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  void loadPrescriptions() {
    try {
      isLoading.value = true;
      final allPrescriptions = DatabaseService.getAllPrescriptions();
      prescriptions.assignAll(allPrescriptions);

      // Verify prescription images exist
      for (var prescription in prescriptions) {
        final imageFile = File(prescription.imagePath);
        if (!imageFile.existsSync()) {
          print(
            'Warning: Prescription image not found at ${prescription.imagePath}',
          );
        } else {
          print('Prescription image found at ${prescription.imagePath}');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load prescriptions: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> uploadPrescription({
    required String doctorName,
    required String notes,
  }) async {
    try {
      isLoading.value = true;

      // Pick image from gallery
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        Get.snackbar('Error', 'No image selected');
        return false;
      }

      // Save image to app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final prescriptionsDir = Directory('${appDir.path}/prescriptions');

      // Create directory if it doesn't exist
      if (!await prescriptionsDir.exists()) {
        await prescriptionsDir.create(recursive: true);
        print('Created prescriptions directory at ${prescriptionsDir.path}');
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = '${prescriptionsDir.path}/$fileName';
      final savedImage = await File(image.path).copy(targetPath);

      print('Saved prescription image to: ${savedImage.path}');
      print('Image file exists: ${await savedImage.exists()}');

      final prescription = PrescriptionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: savedImage.path,
        doctorName: doctorName,
        uploadDate: DateTime.now(),
        notes: notes,
      );

      await DatabaseService.addPrescription(prescription);
      prescriptions.add(prescription);

      Get.snackbar('Success', 'Prescription uploaded successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload prescription: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePrescription(String id) async {
    try {
      isLoading.value = true;
      final prescription = DatabaseService.getPrescription(id);

      if (prescription != null) {
        final file = File(prescription.imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      await DatabaseService.deletePrescription(id);
      prescriptions.removeWhere((p) => p.id == id);
      Get.snackbar('Success', 'Prescription deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete prescription: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsProcessed(String id) async {
    try {
      final prescription = DatabaseService.getPrescription(id);
      if (prescription != null) {
        final updated = prescription.copyWith(processed: true);
        await DatabaseService.updatePrescription(updated);
        loadPrescriptions();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update: ${e.toString()}');
    }
  }

  int getUnprocessedCount() {
    return prescriptions.where((p) => !p.processed).length;
  }

  List<PrescriptionModel> getRecentPrescriptions({int limit = 5}) {
    final sorted = prescriptions.toList();
    sorted.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    return sorted.take(limit).toList();
  }
}
