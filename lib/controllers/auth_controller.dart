import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doc_remind/models/user_model.dart';
import 'package:doc_remind/services/database_service.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final user = Rx<UserModel?>(null);
  late SharedPreferences prefs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    _loadUserFromPrefs();
  }

  void _loadUserFromPrefs() {
    try {
      final userJson = prefs.getString('currentUser');
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        user.value = UserModel.fromJson(userMap);
        isLoggedIn.value = true;

        // Verify profile image exists
        if (user.value?.profileImagePath != null) {
          final imageFile = File(user.value!.profileImagePath!);
          if (!imageFile.existsSync()) {
            print(
              'Warning: Profile image file not found at ${user.value!.profileImagePath}',
            );
          } else {
            print(
              'Profile image loaded successfully from ${user.value!.profileImagePath}',
            );
          }
        }
      }
    } catch (e) {
      print('Error loading user from prefs: $e');
      isLoggedIn.value = false;
    }
  }

  Future<bool> createUser({
    required String name,
    String? email,
    String? phone,
    String? bloodGroup,
  }) async {
    try {
      isLoading.value = true;

      if (name.trim().isEmpty) {
        Get.snackbar('Error', 'Name is required');
        return false;
      }

      // Create a simple local profile
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        email: email?.isNotEmpty == true ? email! : 'local_user@local.app',
        phone: phone ?? '',
        dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 25)),
        bloodGroup: bloodGroup ?? 'O+',
      );

      // Save user
      await DatabaseService.saveUser(newUser);
      await prefs.setString('currentUser', jsonEncode(newUser.toJson()));

      user.value = newUser;
      isLoggedIn.value = true;

      Get.snackbar('Success', 'Profile created successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create profile: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await DatabaseService.deleteUser();
      await prefs.remove('currentUser');
      user.value = null;
      isLoggedIn.value = false;
      Get.snackbar('Success', 'Logged out');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String bloodGroup,
  }) async {
    try {
      isLoading.value = true;

      if (user.value != null) {
        final updatedUser = user.value!.copyWith(
          name: name,
          phone: phone,
          bloodGroup: bloodGroup,
        );

        // Save to database (SharedPreferences)
        await DatabaseService.saveUser(updatedUser);

        // Update in memory
        user.value = updatedUser;

        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar('Error', 'No user profile found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfileImage() async {
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
      final profileDir = Directory('${appDir.path}/profile');

      // Create directory if it doesn't exist
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
        print('Created profile directory at ${profileDir.path}');
      }

      // Delete old profile image if exists
      if (user.value?.profileImagePath != null) {
        try {
          final oldFile = File(user.value!.profileImagePath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
            print('Deleted old profile image');
          }
        } catch (e) {
          print('Error deleting old profile image: $e');
        }
      }

      final fileName = 'profile_${user.value!.id}.jpg';
      final targetPath = '${profileDir.path}/$fileName';

      // Copy image from temporary location to permanent storage
      final savedImage = await File(image.path).copy(targetPath);

      print('Saved profile image to: ${savedImage.path}');
      print('Image file exists: ${await savedImage.exists()}');

      // Verify the file was copied successfully
      if (!await savedImage.exists()) {
        Get.snackbar('Error', 'Failed to save image');
        return false;
      }

      // Update user with new image path
      if (user.value != null) {
        final updatedUser = user.value!.copyWith(
          profileImagePath: savedImage.path,
        );

        // Save to database
        await DatabaseService.saveUser(updatedUser);
        await prefs.setString('currentUser', jsonEncode(updatedUser.toJson()));

        // Update in memory
        user.value = updatedUser;

        Get.snackbar('Success', 'Profile image updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile image: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
