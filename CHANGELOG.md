# Changelog

All notable changes to Doc Remind will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-09

### Initial Release

This is the first public release of Doc Remind - Smart Health & Medicine Reminder.

#### Added

**Core Features:**
- 💊 Complete medicine management system
  - Add, edit, delete medicines
  - Smart scheduling (specific times and days)
  - Dosage tracking
  - Missed dose tracking
  - Local notifications for medicine reminders

- 📅 Doctor appointment management
  - Schedule appointments with doctors
  - Store doctor details (name, specialty, clinic, phone, notes)
  - Mark appointments as attended
  - Track missed appointments
  - Filter by status (All, Upcoming, Past, Missed)
  - Appointment reminders

- 📄 Prescription management
  - Upload prescription photos from camera or gallery
  - Interactive image viewer with zoom (0.5x-4.5x)
  - Prescription status tracking (Pending, Processed)
  - Secure local storage
  - Delete outdated prescriptions

- 👤 User profile management
  - Simple local profile creation (no authentication needed)
  - Profile photo upload and display
  - Profile information management
  - Settings and preferences

**User Experience:**
- Material Design 3 UI
- Dark mode support
- Bottom navigation with 3 tabs (Home, Calendar, Prescriptions)
- Dashboard overview with stats
- FAB menu for quick actions
- Expandable cards for detailed information
- Responsive design for various screen sizes

**Data Management:**
- Offline-first architecture
- Persistent data storage using Hive
- SharedPreferences for user data
- Image persistence across app restarts
- Duplicate prevention for medicines and appointments
- Success/error feedback messages

**Technical:**
- Flutter 3.9.2
- Dart 3.9.2
- GetX state management
- Hive local database
- Flutter Local Notifications
- Image picker with camera support
- Interactive viewer for images

#### Platform Support

- **Android**: 4.1+ (SDK 16+), tested on SDK 21+
  - 64-bit (arm64-v8a) - 18 MB
  - 32-bit (armeabi-v7a) - 16 MB
  - Universal - 51 MB
  - x86_64 - 20 MB

- **iOS**: Coming soon (in development)

#### Known Limitations

- iOS build not yet available
- Google Play Store distribution coming soon
- Single user profile only (multiple profiles planned)
- No medication interaction warnings (planned)
- No health data export feature (planned)

#### Downloads

All APK files are available in the [releases folder](https://github.com/sabbirmohammad/Doc-Remind/tree/main/releases):

| File | Size | Platform |
|------|------|----------|
| app-arm64-v8a-release.apk | 18 MB | Android 64-bit (Recommended) |
| app-armeabi-v7a-release.apk | 16 MB | Android 32-bit |
| app-x86_64-release.apk | 20 MB | Android x86/Emulator |
| app-release.apk | 51 MB | Android Universal |

#### Installation

See [RELEASES.md](RELEASES.md) for detailed installation instructions.

---

## Upcoming Features

### v1.1.0 (Planned)

- [ ] iOS App Store release
- [ ] Google Play Store distribution
- [ ] Multiple user profiles
- [ ] Medication interaction warnings
- [ ] Health data export (PDF/CSV)
- [ ] Backup and restore functionality

### v1.2.0 (Planned)

- [ ] Medicine interaction checker
- [ ] Health analytics dashboard
- [ ] Medicine refill reminders
- [ ] Doctor contact quick dial
- [ ] Calendar integration

### Future

- Cloud backup option
- Multi-device synchronization
- Advanced health reports
- Integration with health providers
- Wearable device support

---

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## Support

For issues, feature requests, or questions:
- 🐛 [Report Issues](https://github.com/sabbirmohammad/Doc-Remind/issues)
- 💬 [Discussions](https://github.com/sabbirmohammad/Doc-Remind/discussions)
- 📧 Contact: [@sabbirmohammad](https://github.com/sabbirmohammad)

---

**Built with ❤️ for health management | Stay healthy! 🏥**
