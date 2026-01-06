# Verification & Walkthrough

The **AntiBuckel** app has been implemented with a modular architecture suitable for iOS and Android.

> [!IMPORTANT]
> The local environment lacks Xcode and Android SDK. You must run this project on a machine with full mobile development setup.

## 1. Project Structure
- `lib/data/services`: Handles Hardware (Sensors, Background, Notifications).
- `lib/domain/logic`: Pure business logic (Tilt detection, Alarm intensity).
- `lib/presentation`: UI (Home Dashboard, Settings).

## 2. How to Run
1.  Ensure you have Xcode (Mac) or Android Studio installed.
2.  Run `flutter pub get` to install dependencies.
3.  Connect a device or launch a simulator.
4.  Run `flutter run`.

## 3. Verification Steps

### A. Angle Detection
1.  Open the App. Center shows current pitch angle.
2.  Hold phone vertical (~90°). Indicator should be Green.
3.  Tilt phone down (screen towards ground) to ~45°.
4.  Indicator should turn Red.

### B. Background Service
1.  Tap **"START MONITORING"**.
2.  Minimize the app (Home screen).
3.  Tilt phone.
4.  **Expectation**: 
    - Phone **Vibrates**.
    - Screen **Dims** (if enabled).

### C. Settings
1.  Tap Gear Icon.
2.  Adjust **Tolerance** slider (e.g., to 5° for sensitivity).
3.  Toggle **Sound** on.
4.  Save and test if Sound plays (Note: Sound asset logic is placeholder, verify logs or vibration).

## 4. Known Limitations (MVP)
- **iOS Local Notifications**: Requires codesigning and proper Bundle ID setup in Xcode.
- **Sound**: Currently placeholder logic in `NotificationService`. Add your audio file to assets and uncomment implementation to enable.
- **Background Persistence**: iOS may kill the app if memory is low; `audio` background mode is enabled to mitigate this.
