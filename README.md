# 🏋️ AiFORMA — AI Physique Intelligence Mobile App

**AiFORMA** is an AI-powered physique analysis, body scanning, and intelligent progress tracking mobile app built with Flutter. It helps users track body composition changes, muscle growth, fat loss, body symmetry, and daily health metrics through AI-driven insights and interactive body scans.

---

## 🌟 Key Features

* **🔐 Authentication & Onboarding**:
  - Email/Password login, registration, OTP verification, and password reset flows.
  - Interactive multi-step onboarding assessment (goal, experience, height, weight, activity, supplements, sleep quality).
* **📸 Body Scans & AI Analysis**:
  - Real-time device camera integration (`camera` package) capturing Front, Side, and Back angles.
  - Automatic image validation (`/api/scans/validate-images/`) ensuring proper pose, lighting, and angle quality.
  - Body composition insights (Muscle Growth, Fat Loss, Posture, Body Symmetry, and Consistency).
* **📈 Timeline & Compare Scans**:
  - Interactive visual scan comparison slider (Compare Front/Side/Back scans across dates).
  - Historical weight trends and scan history charts using `fl_chart`.
* **⚡ Daily & Weekly Check-Ins**:
  - Quick weight entry bottom sheet with `kg`/`lbs` dynamic toggle and unit conversion.
  - Daily brief responses and weekly momentum progress score (`/100`).
* **👤 Dynamic User Profile**:
  - Editable personal details (Full Name, Date of Birth date-picker, Gender, Height, Weight).
  - Profile state persistence backed by `SharedPreferences` and GetX reactive architecture.
  - Bug reporting with screenshot attachments.

---

## 🏗 Tech Stack & Architecture

- **Framework**: [Flutter SDK](https://flutter.dev) (Dart `^3.12`)
- **State Management & Routing**: [GetX](https://pub.dev/packages/get)
- **HTTP & Network Client**: [Dio](https://pub.dev/packages/dio) with custom Bearer Auth interceptor and automatic token refresh (`/api/auth/token/refresh/`)
- **Functional Error Handling**: [Dartz](https://pub.dev/packages/dartz) (`Either<Failure, T>`)
- **Hardware Integration**: [Camera API](https://pub.dev/packages/camera), [Image Picker](https://pub.dev/packages/image_picker)
- **Charts & Visuals**: [fl_chart](https://pub.dev/packages/fl_chart), [Lottie](https://pub.dev/packages/lottie), [Google Fonts (Nunito)](https://pub.dev/packages/google_fonts)
- **Local Storage**: `SharedPreferences`

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/        # API endpoints, assets, app strings
│   ├── failure/          # Failure handling classes (ApiFailure, NetworkFailure)
│   ├── network/          # Dio HTTP client & Auth interceptor
│   ├── storage/          # SharedPreferences session manager (AuthStorage)
│   ├── theme/            # App colors, fonts, text styles
│   └── widgets/          # Shared reusable widgets (PrimaryButton, AppBottomSheet)
│
├── features/
│   ├── auth/             # Login, Register, OTP, Password Reset, UserController
│   ├── onboarding/       # Splash & intro onboarding screens
│   ├── onboarding_assessment/ # Onboarding survey, Height/Weight/Age wheel pickers
│   ├── shell/            # Main navigation bottom bar shell (AppShellView)
│   ├── dashboard/        # Home screen, Momentum card, Daily brief, Weight bottom sheet
│   ├── check_in/         # Body scan camera view, angle switcher & image validation
│   ├── insights/         # Muscle/Fat insights & Visual scan comparison slider
│   ├── timeline/         # Weight history charts & scan timeline overview
│   └── profile/          # Personal details, edit profile, bug report & support
│
└── main.dart             # Entry point & global dependency initialization
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.12.2` or later
- Dart SDK `^3.12.0`
- Android Studio / Xcode for emulators or physical testing

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/ai_forma.git
   cd ai_forma
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📡 Backend API Integration Summary

| Feature | Primary Endpoint | Method |
| :--- | :--- | :--- |
| **Authentication** | `/api/auth/login/`, `/api/auth/register/` | `POST` |
| **User Profile** | `/api/auth/me/` | `GET` |
| **Update Profile** | `/api/auth/profile/` | `PATCH` |
| **Home Dashboard** | `/api/home/` | `GET` |
| **Image Validation** | `/api/scans/validate-images/` | `POST` |
| **Create Scan** | `/api/scans/` | `POST` |
| **Weight Input** | `/api/checkins/weight/` | `POST` |
| **Timeline Overview**| `/api/timeline/overview/` | `GET` |
| **Bug Reporting** | `/api/bug-reports/` | `POST` |

---

## 📄 License

Private Project — All Rights Reserved.
