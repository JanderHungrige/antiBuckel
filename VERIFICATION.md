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
```bash
brew install cocoapods
```
Then run `flutter run` again.

**"No valid code signing certificates" Error (iOS)**
This means Xcode doesn't have your Apple ID permissions to install apps on your phone.
1.  Run the helper script:
    ```bash
    ./scripts/open_xcode_signing.sh
    ```
2.  In Xcode, select the **Runner** project (blue icon, top left).
3.  Choose the **Runner** TARGET.
4.  Go to **Signing & Capabilities** -> **Team** -> **Add an Account**.
5.  Login with your Apple ID.
6.  **Repeat** this for the `BuckelWidget` target if you created it.
7.  If deploying to a physical phone, you may need to go to **Settings > General > VPN & Device Management** on your iPhone and "Trust" your Apple ID.

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

### D. Home Screen Widget & Shortcuts
#### Android
1.  Go to Home Screen.
2.  Long press -> Widgets.
3.  Find **BuckelFips** and drag it to home screen.
4.  **Expectation**: Shows status ("Inactive").
5.  Start monitoring in app -> Widget should update to "Active" (might need tap/refresh if implementation is passive).
6.  **Shortcuts**: Long press app icon -> See "Start Monitoring". Tap it -> Service starts.

#### iOS (Manual Setup Required)
Since the Widget Extension requires a native Xcode Target, you must add it manually:
1.  Open `ios/Runner.xcworkspace` in Xcode.
2.  **File > New > Target** -> Search "Widget Extension" -> Next.
3.  Name: `BuckelWidget`. Uncheck "Include Live Activity" (for now). Finish.
4.  **Important**: Select the main `Runner` target AND the new `BuckelWidget` target. Go to **Signing & Capabilities**.
5.  Click `+ Capability` -> **App Groups**. Add a new group: `group.com.example.antibuckel`. (Do this for BOTH targets).
6.  Open `BuckelWidget/BuckelWidget.swift` and paste this code:
    ```swift
    import WidgetKit
    import SwiftUI

    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> SimpleEntry {
            SimpleEntry(date: Date(), isRunning: false)
        }
        func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
            completion(SimpleEntry(date: Date(), isRunning: false))
        }
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            // Read shared data
            let userDefaults = UserDefaults(suiteName: "group.com.example.antibuckel")
            let isRunning = userDefaults?.bool(forKey: "is_running") ?? false
            let entry = SimpleEntry(date: Date(), isRunning: isRunning)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

    struct SimpleEntry: TimelineEntry {
        let date: Date
        let isRunning: Bool
    }

    struct BuckelWidgetEntryView : View {
        var entry: Provider.Entry
        var body: some View {
            VStack {
                Text(entry.isRunning ? "Active" : "Inactive")
                    .font(.headline)
                    .foregroundColor(entry.isRunning ? .green : .gray)
                Text("BuckelFips")
                    .font(.caption)
            }
        }
    }

    @main
    struct BuckelWidget: Widget {
        let kind: String = "BuckelWidget"
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                BuckelWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Status")
            .description("Shows monitoring status.")
        }
    }
    ```
7.  Run the app again (`flutter run`). Add the widget to your iOS Home Screen.

## 4. Known Limitations (MVP)
- **iOS Local Notifications**: Requires codesigning and proper Bundle ID setup in Xcode.
- **Sound**: Currently placeholder logic in `NotificationService`. Add your audio file to assets and uncomment implementation to enable.
- **Background Persistence**: iOS may kill the app if memory is low; `audio` background mode is enabled to mitigate this.
