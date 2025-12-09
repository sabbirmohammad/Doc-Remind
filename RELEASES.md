# 📥 Doc Remind - Installation & Downloads

## Android Installation

### Available APK Files

| APK Type        | Architecture | Size  | Device Type                          | Download                                         |
| --------------- | ------------ | ----- | ------------------------------------ | ------------------------------------------------ |
| **Recommended** | arm64-v8a    | 18 MB | 64-bit phones (99% of modern phones) | [Download](https://github.com/sabbirmohammad/Doc-Remind/raw/main/releases/app-arm64-v8a-release.apk)   |
| 32-bit Support  | armeabi-v7a  | 16 MB | Older 32-bit phones                  | [Download](https://github.com/sabbirmohammad/Doc-Remind/raw/main/releases/app-armeabi-v7a-release.apk) |
| Emulator/Tablet | x86_64       | 20 MB | Android emulator, tablets            | [Download](https://github.com/sabbirmohammad/Doc-Remind/raw/main/releases/app-x86_64-release.apk)      |
| Universal APK   | Universal    | 51 MB | All Android devices                  | [Download](https://github.com/sabbirmohammad/Doc-Remind/raw/main/releases/app-release.apk)             |

### How to Install

#### Method 1: Direct APK Installation (Easiest)

1. **Download** the appropriate APK from the links above
2. **Transfer** the APK file to your Android phone
3. **Open** the APK file with your file manager
4. **Tap** "Install" and allow permissions
5. **Done!** The app will be installed

> ⚠️ **Note**: You may need to enable "Install from Unknown Sources" in Settings → Security

#### Method 2: Using ADB (Advanced)

```bash
# Download APK first, then:
adb install path/to/app-arm64-v8a-release.apk
```

#### Method 3: Google Play Store (Coming Soon)

The app will be published to Google Play Store soon for easy installation and updates.

## iOS Installation

### Coming Soon ⏳

iOS builds are currently being prepared. The `.ipa` file will be available soon for:

- TestFlight Beta testing
- App Store release
- Direct installation on iOS devices

For now, you can:

- **Build from source**: Clone the repository and build with `flutter build ios --release`
- **Use Flutter CLI**: Install the app on iOS simulator or device

## System Requirements

### Android

- **Minimum**: Android 6.0 (API 21)
- **Recommended**: Android 8.0+ (API 26+)
- **Target**: Android 14 (API 34)

### iOS

- **Minimum**: iOS 11.0
- **Recommended**: iOS 13.0+
- **Target**: iOS 17.0+

## Features by Version

### v1.0.0 (Current)

✅ **Core Features**

- Local user profile management
- Medicine tracking with scheduling
- Doctor appointment management
- Prescription photo storage
- Persistent offline storage
- Duplicate prevention
- Missed item tracking
- Dark/Light theme support

## Troubleshooting

### Android Installation Issues

**Problem**: "Unknown provider" error

- **Solution**: Uninstall any previous version first, then install the new APK

**Problem**: App crashes on startup

- **Solution**:
  1. Clear app cache: Settings → Apps → Doc Remind → Storage → Clear Cache
  2. Uninstall and reinstall the app

**Problem**: File permissions denied

- **Solution**: Grant permissions when app requests them, or manually enable in Settings → Apps → Doc Remind → Permissions

### Storage Issues

**Problem**: Images not showing after restart

- **Solution**: This is fixed in v1.0.0 - images are stored permanently in app documents directory

## Getting Help

- 📝 **Report Issues**: [Create an issue on GitHub](https://github.com/sabbirmohammad/Doc-Remind/issues)
- 📧 **Contact**: Open an issue or discussion in the repository
- 💬 **Discussions**: Check GitHub Discussions for FAQs

## Build from Source

If you prefer to build the app yourself:

```bash
# Clone repository
git clone https://github.com/sabbirmohammad/Doc-Remind.git
cd Doc-Remind

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release

# Or split APKs
flutter build apk --release --split-per-abi
```

Built APKs will be in `build/app/outputs/flutter-apk/`

## App Permissions

### Android Permissions Required

- **READ_EXTERNAL_STORAGE**: For accessing images from gallery
- **WRITE_EXTERNAL_STORAGE**: For saving prescription images
- **CAMERA**: For taking prescription photos
- **SCHEDULE_EXACT_ALARM**: For medication reminders

### iOS Permissions Required

- **Photo Library Access**: For selecting prescription photos
- **Camera Access**: For taking prescription photos
- **Calendar Access**: For appointment notifications

---

<div align="center">
  <p>⭐ <strong>Like this app?</strong> Please star the repository!</p>
  <p>Made with ❤️ using Flutter</p>
</div>
