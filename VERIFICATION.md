# Verification & Walkthrough

The **AntiBuckel** app has been implemented with a modular architecture suitable for iOS and Android.

> [!IMPORTANT]
> The local environment lacks Xcode and Android SDK. You must run this project on a machine with full mobile development setup (e.g., your personal Mac).

## 1. Project Structure
- `lib/data/services`: Handles Hardware (Sensors, Background, Notifications).
- `lib/domain/logic`: Pure business logic (Tilt detection, Alarm intensity).
- `lib/presentation`: UI (Home Dashboard, Settings).

## 2. How to Run (Detailed)

You do **not** need to open Xcode or Android Studio explicitly to run the app, but they must be installed as they provide the underlying tools and simulators.

### Roles of the Tools
- **Flutter**: The main tool you interact with. It compiles your Dart code and tells Xcode/Android Studio what to do.
- **Xcode / Android Studio**: These are the "Engines". Flutter uses them in the background to build the native iOS/Android app.
- **Simulator / Emulator**: These are the virtual phones that will pop up on your screen when you run the app.

### Step-by-Step Guide

**1. Open your Terminal (or VS Code)**
Navigate to the project folder where you cloned the code.
```bash
cd antiBuckel
```

**2. install Dependencies**
This downloads all the plugins (like sensors, vibration) used in the project.
```bash
flutter pub get
```

**3. Launch a Simulator**
- **iOS**: You can open the "Simulator" app via Spotlight Search (Cmd+Space -> Type "Simulator").
- **Android**: Open Android Studio Device Manager and start an emulator.
- *Alternatively*, just connect your physical phone via USB.

**4. Run the App**
In your terminal, run:
```bash
flutter run
```
*What happens next?*
- Flutter will detect your open simulator or connected phone.
- It will compile the code (this takes 1-2 minutes the first time).
- The app will automatically open on the Simulator/Phone.
- Your terminal will show logs. **Keep the terminal open** to see debug output.

### Troubleshooting
**"CocoaPods not installed" Error**
If you see an error about CocoaPods on iOS, it means your Mac is missing the dependency manager for Xcode.
Run this command in your terminal:
```bash
brew install cocoapods
```
Then run `flutter run` again.

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
