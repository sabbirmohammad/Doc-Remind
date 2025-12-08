import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doc_remind/theme/app_theme.dart';
import 'package:doc_remind/controllers/auth_controller.dart';
import 'package:doc_remind/controllers/theme_controller.dart';
import 'package:doc_remind/controllers/medicine_controller.dart';
import 'package:doc_remind/controllers/appointment_controller.dart';
import 'package:doc_remind/controllers/prescription_controller.dart';
import 'package:doc_remind/services/database_service.dart';
import 'package:doc_remind/services/notification_service.dart';
import 'package:doc_remind/screens/login_screen.dart';
import 'package:doc_remind/screens/home_screen.dart';
import 'package:doc_remind/screens/add_medicine_screen.dart';
import 'package:doc_remind/screens/add_appointment_screen.dart';
import 'package:doc_remind/screens/settings_screen.dart';
import 'package:doc_remind/screens/medicines_list_screen.dart';
import 'package:doc_remind/screens/appointments_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database
  await DatabaseService.initDatabase();

  // Initialize Notifications
  await NotificationService.initNotifications();
  await NotificationService.requestPermissions();

  // Initialize Controllers
  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(MedicineController());
  Get.put(AppointmentController());
  Get.put(PrescriptionController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Doc Remind',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: authController.isLoggedIn.value
            ? const HomeScreen()
            : const LoginScreen(),
        getPages: [
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/home', page: () => const HomeScreen()),
          GetPage(name: '/add-medicine', page: () => const AddMedicineScreen()),
          GetPage(
            name: '/add-appointment',
            page: () => const AddAppointmentScreen(),
          ),
          GetPage(name: '/settings', page: () => const SettingsScreen()),
          GetPage(name: '/medicines', page: () => const MedicinesListScreen()),
          GetPage(
            name: '/appointments',
            page: () => const AppointmentsListScreen(),
          ),
        ],
      ),
    );
  }
}
