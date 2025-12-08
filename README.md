# 📱 Doc Remind - Smart Health & Medicine Reminder

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

**A comprehensive health management app for tracking medicines, appointments, and prescriptions**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Tech Stack](#-tech-stack) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

Doc Remind is a Flutter-based mobile application designed to help users manage their health by tracking medications, doctor appointments, and medical prescriptions. Built with a focus on simplicity and offline-first functionality, it ensures your health data is always accessible without requiring an internet connection.

## ✨ Features

### 💊 Medicine Management
- **Add & Track Medicines**: Store medicine details including name, dosage, and schedule
- **Smart Scheduling**: Configure specific times and days of the week for each medicine
- **Missed Doses Tracking**: Automatic tracking of missed medication doses
- **Notifications**: Timely reminders for medicine intake
- **Duplicate Prevention**: Automatic detection of duplicate medicines
- **Full CRUD Operations**: Add, edit, view, and delete medicines

### 📅 Appointment Management
- **Doctor Appointments**: Schedule and manage appointments with doctors
- **Appointment Details**: Store doctor name, specialty, clinic, phone, date/time, and notes
- **Status Tracking**: Mark appointments as attended or track missed appointments
- **Smart Filtering**: View All, Upcoming, Past, or Missed appointments
- **Appointment Reminders**: Get notified before your appointments
- **Duplicate Detection**: Prevents scheduling duplicate appointments

### 📄 Prescription Management
- **Photo Storage**: Take or upload photos of prescriptions
- **Zoom & View**: Interactive viewer with pinch-to-zoom (0.5x-4x)
- **Persistent Storage**: Images stored permanently in app documents
- **Organization**: Keep all prescriptions organized in one place
- **Delete Option**: Remove outdated prescriptions easily

### 👤 User Profile
- **Local Profile**: Simple profile creation without authentication
- **Profile Photo**: Upload and display profile picture
- **Settings**: Manage app preferences and user information
- **Dark Mode**: Toggle between light and dark themes

### 🎨 UI/UX Features
- **Material Design 3**: Modern, clean interface
- **Intuitive Navigation**: Bottom navigation with Home, Calendar, and Prescriptions
- **Dashboard Overview**: Quick stats for medicines, appointments, and missed items
- **Expandable Cards**: Detailed views with smooth animations
- **Responsive Design**: Optimized for various screen sizes
- **No Debug Banner**: Clean production-ready UI

## 📸 Screenshots

<div align="center">
  
### Dashboard & Home
<img src="screenshots/dashboard_light.png" width="250" alt="Dashboard Light Mode"> <img src="screenshots/dashboard_dark.png" width="250" alt="Dashboard Dark Mode"> <img src="screenshots/fab_menu.png" width="250" alt="FAB Menu">

### Medicine Management
<img src="screenshots/add_medicine.png" width="250" alt="Add Medicine"> <img src="screenshots/medicine_calendar.png" width="250" alt="Medicine Calendar">

### Appointment Management
<img src="screenshots/add_appointment.png" width="250" alt="Add Appointment"> <img src="screenshots/appointments_list.png" width="250" alt="Appointments List">

### Prescription Management
<img src="screenshots/prescriptions_list.png" width="250" alt="Prescriptions List"> <img src="screenshots/prescription_details.png" width="250" alt="Prescription Details"> <img src="screenshots/prescription_pending.png" width="250" alt="Prescription Pending">

</div>

## 🚀 Installation

### Prerequisites
- Flutter SDK (≥3.9.2)
- Dart SDK (≥3.9.2)
- Android Studio / Xcode (for mobile development)
- Android SDK (for Android builds)

### Setup Steps

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/doc_remind.git
cd doc_remind
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate model files**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### Build APK (Android)

**Split APKs (Recommended - smaller size)**
```bash
flutter build apk --release --split-per-abi
```
Output:
- `app-armeabi-v7a-release.apk` (16.8 MB) - 32-bit devices
- `app-arm64-v8a-release.apk` (19.4 MB) - 64-bit devices (most common)
- `app-x86_64-release.apk` (20.5 MB) - Emulators/tablets

**Universal APK**
```bash
flutter build apk --release
```
Output: `app-release.apk` (51 MB)

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter 3.9.2
- **Language**: Dart 3.9.2
- **UI**: Material Design 3

### State Management
- **GetX** (4.6.6) - Reactive state management, routing, and dependency injection

### Local Storage
- **Hive** (2.2.3) - NoSQL local database for medicines, appointments, prescriptions
- **SharedPreferences** (2.2.2) - Key-value storage for user data
- **Path Provider** (2.1.1) - Permanent file storage for images

### Features & Utilities
- **Image Picker** (1.0.4) - Camera and gallery access
- **Flutter Local Notifications** (17.0.0) - Push notifications
- **Timezone** (0.9.2) - Timezone management for notifications
- **Intl** (0.19.0) - Date/time formatting
- **Table Calendar** (3.0.9) - Calendar widget
- **Font Awesome Flutter** (10.7.0) - Icon library

### Development Tools
- **Build Runner** (2.4.6) - Code generation
- **Hive Generator** (2.0.0) - Model generation

## 📁 Project Structure

```
lib/
├── controllers/          # GetX controllers
│   ├── appointment_controller.dart
│   ├── auth_controller.dart
│   ├── medicine_controller.dart
│   ├── prescription_controller.dart
│   └── theme_controller.dart
├── models/              # Data models with Hive adapters
│   ├── appointment_model.dart
│   ├── medicine_model.dart
│   ├── prescription_model.dart
│   └── user_model.dart
├── screens/             # UI screens
│   ├── dashboard_screen.dart
│   ├── home_screen.dart
│   ├── add_medicine_screen.dart
│   ├── medicines_list_screen.dart
│   ├── add_appointment_screen.dart
│   ├── appointments_list_screen.dart
│   ├── prescription_screen.dart
│   ├── calendar_screen.dart
│   └── settings_screen.dart
├── services/            # Business logic services
│   ├── database_service.dart
│   └── notification_service.dart
├── theme/               # App theming
│   └── app_theme.dart
├── widgets/             # Reusable widgets
│   └── medicine_card.dart
└── main.dart           # App entry point
```

## 🔑 Key Features Implementation

### Data Persistence
- Images stored in app documents directory (survives app restarts)
- Hive boxes for structured data (medicines, appointments, prescriptions)
- SharedPreferences for user profile data

### Duplicate Prevention
- **Medicines**: Case-insensitive name matching
- **Appointments**: Doctor name + date + time matching
- User-friendly error messages on duplicate detection

### Notifications
- Scheduled local notifications for medicines
- Appointment reminders before scheduled time
- Timezone-aware scheduling

### Image Management
- Profile photos stored in `/profile` directory
- Prescription photos in `/prescriptions` directory
- Automatic cleanup of old images on update
- File existence verification on app load

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Sabbir Mohammad**
- GitHub: [@sabbirmohammad](https://github.com/sabbirmohammad)
- Repository: [Doc-Remind](https://github.com/sabbirmohammad/Doc-Remind)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX community for excellent state management
- All contributors and users of this app

## 📧 Support

For support, please open an issue in the GitHub repository or contact [your-email@example.com]

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Star this repo if you find it helpful!</p>
</div>
