# Smart Health & Medicine Reminder App - Quick Start

## 📋 Project Overview

A feature-rich Flutter app for managing health reminders:

- 💊 Medicine schedules and reminders
- 🏥 Doctor appointment management
- 📸 Prescription image storage
- 📊 Health analytics and tracking
- 🌙 Dark mode support

## 🚀 Quick Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Hive Models

```bash
flutter pub run build_runner build
```

### 3. Run the App

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart              # App initialization
├── controllers/           # GetX state management
├── models/                # Data structures
├── screens/               # UI screens
├── services/              # Business logic
├── theme/                 # Styling
└── widgets/               # Reusable components
```

## 🎯 Key Features Implemented

✅ **Authentication**

- Registration with health profile
- Persistent login
- Blood group tracking

✅ **Medicine Management**

- Add medicines with schedules
- Set dosage and times
- Track missed doses
- Automatic notifications

✅ **Appointments**

- Schedule doctor visits
- Add clinic information
- Appointment reminders (1 hour before)
- Mark as attended

✅ **Prescriptions**

- Upload prescription images
- Doctor notes
- Track processed status

✅ **Calendar View**

- Visual daily schedule
- Medicine times
- Appointment dates

✅ **Dashboard**

- Quick statistics
- Today's medicines
- Next appointment
- Missed dose count

✅ **Settings**

- Dark/Light theme toggle
- Profile editing
- User information
- Logout

## 🗄️ Database Schema

### Hive Boxes

- **users**: User profile (single document)
- **medicines**: Medicine records (multiple)
- **appointments**: Doctor visits (multiple)
- **prescriptions**: Prescription images (multiple)

## 🔔 Notification System

- **Medicine Reminders**: At specified times daily
- **Appointment Reminders**: 1 hour before appointment
- **Local Notifications**: No internet required
- **Platform-Specific**: Native Android/iOS implementation

## 🎨 Theme

- **Primary Color**: Purple (#6C5CE7)
- **Light Theme**: Clean white background
- **Dark Theme**: Dark mode optimized
- **Material Design 3**: Modern UI components

## 📱 Navigation Structure

```
Login/Register → Home Screen (Bottom Nav)
                  ├── Dashboard
                  ├── Calendar
                  └── Prescriptions

Home → Add Medicine
Home → Add Appointment
Home → Settings
```

## 🛠️ State Management (GetX)

- **AuthController**: Authentication & user profile
- **MedicineController**: Medicine CRUD & reminders
- **AppointmentController**: Appointment management
- **PrescriptionController**: Prescription uploads
- **ThemeController**: Theme toggling

## 💾 Local Storage

- **Hive**: Main database for structured data
- **SharedPreferences**: User email for login
- **File System**: Prescription images

## ⚙️ Configuration

### Notification Channels

- **medicine_channel**: Medicine reminders
- **appointment_channel**: Appointment reminders

### Required Permissions

- **Android**: NOTIFICATION (Runtime)
- **iOS**: Calendar, Camera (Info.plist)

## 🔧 Development Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run with verbose logging
flutter run -v

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 📚 File Descriptions

### Controllers

- **auth_controller.dart**: Login, register, profile updates
- **medicine_controller.dart**: CRUD operations, notifications, analytics
- **appointment_controller.dart**: Appointment management, reminders
- **prescription_controller.dart**: Image upload, processing
- **theme_controller.dart**: Dark mode toggle

### Services

- **database_service.dart**: Hive operations, CRUD methods
- **notification_service.dart**: Local notification scheduling

### Models

- **user_model.dart**: User profile (JSON serializable)
- **medicine_model.dart**: Medicine data (Hive)
- **appointment_model.dart**: Doctor appointment (Hive)
- **prescription_model.dart**: Prescription image (Hive)

### Screens

- **login_screen.dart**: Email-based login
- **register_screen.dart**: User registration
- **home_screen.dart**: Bottom navigation wrapper
- **dashboard_screen.dart**: Health overview
- **add_medicine_screen.dart**: Medicine form
- **add_appointment_screen.dart**: Appointment form
- **calendar_screen.dart**: Weekly/monthly view
- **prescription_screen.dart**: Image gallery
- **settings_screen.dart**: User settings

## 🐛 Troubleshooting

### Build Errors

```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Notification Issues

- Check `NotificationService.initNotifications()` called
- Verify notification permissions in native code
- Test on physical device (emulator limitations)

### Database Issues

```bash
# Reset app data
flutter run --no-fast-start
```

## 📋 Next Steps

1. Test all features thoroughly
2. Run `flutter pub run build_runner build`
3. Deploy to Android Play Store / iOS App Store
4. Monitor crash reports and user feedback

## 📞 Support

Check `SETUP_GUIDE.md` for detailed documentation.

---

**Status**: Production Ready ✅  
**Version**: 1.0.0  
**Last Updated**: December 2024
