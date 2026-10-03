# AiFORMA - AI Physique Intelligence Mobile App

AiFORMA is an AI-powered physique intelligence, body composition scanning, and progress-tracking mobile application developed with Flutter. It enables athletes, fitness enthusiasts, and physique-conscious individuals to track body composition changes, muscle growth, fat loss, posture, and symmetry through camera-assisted 3-angle body scans and interactive AI-driven analytics.

---

## Developer Handover Guide

This document serves as the official developer handover and technical reference for AiFORMA. If you are a new software engineer joining or taking over this project, this guide provides everything you need to understand the architecture, key design decisions, gotchas, roadmap, and production build pipelines.

---

## Technical Specifications and Stack

* **Framework**: Flutter (Dart 3.x)
* **Architecture**: Clean Architecture with Feature-First modular structure (Data, Controllers, Views)
* **State Management and Routing**: GetX (`GetxController`, `Obx`, declarative named routes)
* **Networking**: Dio 5.x with custom Bearer Auth interceptor, automatic token refresh (`/api/auth/token/refresh/`), and multipart image uploads
* **Functional Error Handling**: Dartz (`Either<Failure, T>`)
* **Secure Storage**: `flutter_secure_storage` (Android KeyStore / iOS Keychain) combined with `shared_preferences`
* **Hardware Integrations**: `camera` package (Front, Side, Back multi-angle photo capture), `image_picker`
* **Analytics and Crash Reporting**: Firebase Core, Firebase Messaging (FCM), Firebase Crashlytics
* **Data Visualization**: `fl_chart` (Interactive weight and metric trend series)
* **Typography**: Nunito (Bundled local font assets in `assets/fonts/Nunito/` for 100% offline rendering)
* **Logging System**: `flutter_devlog` (Zero-overhead release compilation via Dart `assert` stripping)

---

## Codebase Architecture and Directory Layout

The project follows a **Feature-First Clean Architecture** pattern. All business logic, state controllers, and UI screens are isolated inside dedicated feature directories under `lib/features/`:

```text
lib/
|-- core/                                # Shared foundational modules
|   |-- constants/                       # API endpoints, assets, app strings
|   |-- failure/                         # Failure abstraction models (ApiFailure, NetworkFailure)
|   |-- icons/                           # Centralized icon definitions (Remix Icon + custom SVGs)
|   |-- network/                         # DioClient, AuthInterceptor, LoggerInterceptor
|   |-- services/                        # PushNotificationService, Background FCM handlers
|   |-- storage/                         # AuthStorage (SecureStorage + SharedPreferences)
|   |-- theme/                           # AppColors, AppTheme, AppTextStyles
|   `-- widgets/                         # Reusable core widgets (PrimaryButton, AppNavbar, AppIcon)
|
|-- features/                            # Domain-driven feature modules
|   |-- auth/                            # Authentication (Login, Register, OTP, Password Reset, UserController)
|   |-- onboarding/                      # Initial welcome and intro carousels
|   |-- onboarding_assessment/           # Multi-step intake survey with wheel pickers
|   |-- shell/                           # Navigation shell with bottom navbar (AppShellView)
|   |-- dashboard/                       # Home screen, Momentum card, Daily brief, Weight log
|   |-- check_in/                        # 3-Angle Camera scanner, Pose overlay, Image validator
|   |-- insights/                        # Muscle, Fat, Posture, Symmetry metrics, Scan comparison slider
|   |-- timeline/                        # Historical scan archive, Weight trend analytics
|   `-- profile/                         # User profile, Notification settings, Subscription, Bug reports
|
|-- routes/                              # Declarative routing table and route guards (AppRoutes, RoutesName)
|-- firebase_options.dart                # Generated Firebase options configuration
`-- main.dart                            # Application entry point, crash boundaries, dependency injection
```

---

## Key Engineering Workflows and Gotchas

### 1. Authentication and Token Lifecycle
* **Hardware Storage**: Authentication tokens (`access_token`, `refresh_token`) are stored in hardware-encrypted storage using `flutter_secure_storage` (Android KeyStore / iOS Keychain).
* **Automatic Silent Renewal**: `AuthInterceptor` in `lib/core/network/auth_interceptor.dart` intercepts `401 Unauthorized` responses, calls `/api/auth/token/refresh/` using the refresh token, updates secure storage, and seamlessly replays the original failed request.
* **iOS Keychain Persistence Gotcha (`ensureCleanInstall`)**:
  - By Apple's OS design, iOS Keychain data **persists across app uninstalls**.
  - `AuthStorage.ensureCleanInstall()` checks an install marker in `SharedPreferences` (which iOS wipes on uninstall). If missing, it purges orphaned Keychain credentials to ensure fresh installs always prompt for onboarding and login.

### 2. 3-Angle Camera Scanning Pipeline
* Live camera preview (`CameraPreview`) in `lib/features/check_in/view/pages/camera_scan_view.dart` guides the user through three mandatory capture angles: **Front**, **Side**, and **Back**.
* Real-time pose silhouettes assist the user in standing at the proper distance.
* Photos are validated against `/api/scans/validate-images/` before final submission to verify lighting, orientation, and silhouette framing.

### 3. Production Crash Reporting and Global Error Boundaries
* In `lib/main.dart`, synchronous Flutter framework errors (`FlutterError.onError`), unhandled asynchronous platform errors (`PlatformDispatcher.instance.onError`), and zoned root exceptions (`runZonedGuarded`) are piped directly to **Firebase Crashlytics**.
* Active user IDs are tagged in Crashlytics via `FirebaseCrashlytics.instance.setUserIdentifier(userId)` upon login and cleared upon logout.
* A user-friendly branded recovery screen replaces the default red/grey screen of death in release builds (`ErrorWidget.builder`).

### 4. Logging Standard: No Raw Prints
* Never use raw `print()` or `debugPrint()` in the codebase.
* All console emissions use `flutter_devlog`:
  ```dart
  DevLog.info('Message', tag: 'Tag');
  DevLog.error('Error occurred', tag: 'Tag', error: e, stackTrace: s);
  DevLog.api('GET request ==> /api/home/');
  ```
* All `DevLog` methods are encapsulated in Dart `assert()` blocks. When building for production release, the compiler strips these assertions completely, producing zero console leak and zero runtime overhead.

### 5. Asset Manifest Case-Sensitivity
* Assets are declared in `pubspec.yaml` under `assets/Icons/`, `assets/app/`, `assets/preview/`, and `assets/fonts/Nunito/`.
* Always match the exact casing specified in `AppIcons` (`assets/Icons/...`).

---

## Production Build System

All production builds must supply the target API URL via Dart environment definitions using `--dart-define=API_URL=...`.

The base URL is configured in `lib/core/constants/api_endpoint.dart`:
```dart
class ApiEndpoint {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://aiformapi.sobhoy.com',
  );
  ...
}
```

### Production Build Prerequisites
1. **Flutter SDK**: `^3.12.0` or higher
2. **Android SDK**: Compile SDK `37` (configured in `android/app/build.gradle.kts`)
3. **Android Keystore**: `android/app/upload-keystore.jks` and `android/key.properties`
4. **Xcode**: Xcode 15 or higher with valid Apple Developer provisioning profile

---

### Android Production Release (Google Play Console)

To build the signed, minified, and optimized Android App Bundle (AAB):

```bash
flutter build appbundle --release --dart-define=API_URL=https://aiformapi.sobhoy.com
```

* **Output Artifact**: `build/app/outputs/bundle/release/app-release.aab`
* **Signing**: Signed automatically with `android/app/upload-keystore.jks` via credentials in `android/key.properties`.
* **R8 Code Shrinking and Resource Minification**:
  - `isMinifyEnabled = true` and `isShrinkResources = true` are active in `android/app/build.gradle.kts`.
  - Custom rules in `android/app/proguard-rules.pro` preserve Flutter engine internals, Firebase Crashlytics, and FlutterSecureStorage JNI bindings.
* **Play Console Destination**: Upload to Google Play Console -> **Testing** -> **Closed testing** (or Production track).

---

### iOS Production Release (Apple TestFlight / App Store)

To build the signed iOS archive:

```bash
flutter build ipa --release --dart-define=API_URL=https://aiformapi.sobhoy.com
```

* **Output Artifact**: `build/ios/archive/Runner.xcarchive` (or `.ipa` inside `build/ios/ipa/`)
* **Permissions in Info.plist**:
  - `NSCameraUsageDescription` (weekly body scans)
  - `NSPhotoLibraryUsageDescription` (gallery check-in selection)
  - `UIBackgroundModes`: `fetch`, `remote-notification`
* **Distribution Destination**: Submit via Apple Transporter or Xcode Organizer to **App Store Connect / TestFlight**.

---

## Project Status and Handover Roadmap

### Current Completion: ~93% (Closed Testing Ready)

All critical business workflows, authentication, body scanning, AI reporting, crash monitoring, and profile management are 100% operational.

### Outstanding Tasks for General Availability (100% Launch)

1. **Native In-App Purchases (StoreKit 2 / Google Play Billing)**:
   - Current status: Deferred for closed testing. The subscription screen (`SubscriptionView`) shows a tester dialog providing `founders@ai-forma.net` for free testers and acknowledging active premium testers.
   - Task: Implement `in_app_purchase` or `purchases_flutter` (RevenueCat) and wire server-side receipt validation at `/api/billing/verify/`.
2. **Production APNs Authentication Key Upload**:
   - Current status: Firebase Messaging client and background handlers are fully wired.
   - Task: Upload the production Apple `.p8` Push Notification key to Firebase Console to ensure delivery to physical release devices.
3. **End-to-End Automated Testing**:
   - Task: Add `integration_test` automation testing the complete flow from login -> 3-angle camera mock -> analysis rendering.
4. **Offline Queueing**:
   - Task: Implement local queueing for daily brief answers and weight inputs when device has no internet connection.

---

## Developer Handover and Support Contact

This project was architected and developed by **Bayajit Islam**.

If you are a developer taking over, maintaining, or extending this project and require technical clarification or onboarding assistance, please reach out:

* **Author and Lead Developer**: Bayajit Islam
* **GitHub Profile**: [https://github.com/bayajitislam](https://github.com/bayajitislam)
* **Email**: [contact@bayajitislam.com](mailto:contact@bayajitislam.com)
* **Repository**: [https://github.com/bayajitislam/ai_forma](https://github.com/bayajitislam/ai_forma)

---

## License

Private Proprietary Software - Copyright AiFORMA. All rights reserved.
