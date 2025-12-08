# Doc Remind - Smart Health & Medicine Reminder App

A comprehensive Flutter application for managing medicines, doctor appointments, and health records with local notifications and offline-first functionality.

## Features

### 🏥 Core Features

- **Medicine Management**: Add medicines with dosage, frequency, and time schedules
- **Doctor Appointments**: Schedule and track doctor visits with reminders
- **Prescription Scanner**: Upload and manage prescription images
- **Analytics**: Track missed doses and appointment statistics
- **Dark Mode**: Beautiful light and dark theme support
- **Local Notifications**: Timely reminders for medicines and appointments

### 👤 User Authentication

- User registration with health profile
- Persistent login with local storage
- Blood group and emergency contact tracking

### 📅 Calendar & Scheduling

- Visual calendar view of medicines and appointments
- Day-wise medicine schedule
- Appointment timeline

### 🔔 Smart Notifications

- Medicine reminders at specified times
- Appointment reminders 1 hour before
- Local notification system (no internet required)

### 🎨 UI/UX

- Clean, modern Material Design 3
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Status cards with health metrics

## Architecture

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (Hive + JSON serializable)
│   ├── medicine_model.dart
│   ├── appointment_model.dart
│   ├── prescription_model.dart
│   └── user_model.dart
├── controllers/              # GetX state management
│   ├── auth_controller.dart
│   ├── medicine_controller.dart
│   ├── appointment_controller.dart
│   ├── prescription_controller.dart
│   └── theme_controller.dart
├── services/                 # Business logic
│   ├── database_service.dart
│   └── notification_service.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── add_medicine_screen.dart
│   ├── add_appointment_screen.dart
│   ├── calendar_screen.dart
│   ├── prescription_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable components
│   └── medicine_card.dart
└── theme/                    # Theme configuration
    └── app_theme.dart
```

## Technologies Used

### State Management

- **GetX** - Reactive state management and routing

### Database

- **Hive** - Local NoSQL database for fast, offline data storage
- **SharedPreferences** - Simple key-value storage for settings

### Notifications

- **flutter_local_notifications** - Local push notifications
- **timezone** - Timezone support for scheduling

### UI

- **Material Design 3** - Modern design system
- **table_calendar** - Calendar widget
- **intl** - Internationalization

### Other

- **image_picker** - Camera and gallery image selection

## Setup & Installation

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK (comes with Flutter)
- iOS 11.0+ or Android 5.0+

### Steps

1. **Clone and Setup**

   ```bash
   cd /path/to/doc_remind
   flutter pub get
   ```

2. **Generate Hive Models** (if models are modified)

   ```bash
   flutter pub run build_runner build
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Usage Guide

### First Launch

1. Register with your details (name, email, phone, blood group)
2. Complete your profile information
3. Navigate to the dashboard

### Adding Medicines

1. Tap "Add Medicine" or the FAB on Dashboard
2. Enter medicine name, dosage, and description
3. Select days of the week
4. Add specific times for reminders
5. Confirm - notifications will be automatically scheduled

### Scheduling Appointments

1. Go to "Add Appointment"
2. Enter doctor details and clinic information
3. Select appointment date and time
4. Save - you'll get a reminder 1 hour before

### Uploading Prescriptions

1. Navigate to Prescriptions tab
2. Tap the camera FAB
3. Select image from gallery
4. Add doctor name and notes
5. Mark as processed when needed

### Tracking Health

- Dashboard shows today's medicines and next appointment
- Statistics cards display medicine count, appointments, and missed doses
- Calendar view shows daily medicine schedule and appointments

### Dark Mode

- Toggle in Settings > Appearance
- Preference is saved locally

## Hive Database Setup

The app uses Hive for local data persistence:

- **users** - User profile and authentication data
- **medicines** - Medicine records with schedules
- **appointments** - Doctor appointment history
- **prescriptions** - Prescription images and metadata

### Generating Hive Adapters

If you modify the models, regenerate adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Notification Permission

### Android

- Notifications are requested at runtime
- Permission is handled automatically

### iOS

- Notification permission is requested on first launch
- User can enable in Settings if denied initially

## Key Features Implementation

### Medicine Reminders

- Scheduled daily at specified times
- Persistent across app restarts
- Can be manually marked as missed
- Tracked in analytics

### Appointment Reminders

- Scheduled 1 hour before appointment
- Shows doctor name and specialty
- Can mark as attended or reschedule

### Prescription Management

- Store prescription images locally
- Track processed vs pending
- Add doctor notes and metadata

### Analytics

- Count missed doses per medicine
- Track missed appointments
- View statistics on dashboard

## Troubleshooting

### Build Issues

```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Notifications Not Working

- Ensure `NotificationService.initNotifications()` is called in `main.dart`
- Check platform-specific notification settings
- For Android: Verify notification channel is created
- For iOS: Check notification permissions in app settings

### Database Issues

```bash
# Reset app data
flutter run --no-fast-start
```

## Future Enhancements

- [ ] Cloud backup with Firebase
- [ ] Sync across devices
- [ ] Family member sharing
- [ ] Medical history export (PDF)
- [ ] Integration with health apps (Apple Health, Google Fit)
- [ ] Prescription OCR recognition
- [ ] Medication interactions checker
- [ ] Reminders via SMS/Email
- [ ] Voice-based reminders
- [ ] Medicine barcode scanner

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure code follows Dart style guide
4. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or suggestions:

1. Create an issue in the repository
2. Check existing issues for solutions
3. Provide detailed error messages and logs

## Performance Tips

- Hive is optimized for mobile - no migration needed
- GetX controllers are lazy initialized
- Images are compressed before storage
- Notifications use native channels for efficiency

## Data Privacy

- All data stored locally on device
- No server communication required
- User can export/delete all data anytime
- No tracking or analytics collection

---

**Version**: 1.0.0  
**Last Updated**: December 2024
