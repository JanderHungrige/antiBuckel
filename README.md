# BuckelFips

**Prevent "Buckel" (Poor Posture) by monitoring your phone tilt.**

This app runs in the background and alerts you via Vibration, Sound, or Screen Dimming when you hold your phone at an angle that forces your head to tilt downwards.

## Features
- **Real-time Tilt Monitoring**: Uses accelerometer data to calculate device pitch.
- **Configurable Thresolds**: Set your own "Good" angle and tolerance buffer (Default: +/- 20°).
- **Multiple Alarm Types**:
  - **Vibration**: Haptic feedback intensity increases as you tilt further.
  - **Sound**: Audio warning.
  - **Dimming**: Screen gets darker as your posture gets worse.
- **Background Service**: Keeps monitoring even when you use other apps (Android/iOS*).

## Getting Started

> [!NOTE]
> For detailed testing instructions, please check [VERIFICATION.md](VERIFICATION.md).

### Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / Xcode

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/JanderHungrige/antiBuckel.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Architecture
The project follows **Clean Architecture**:
- **Domain**: Pure business logic (Tilt math, Alarm logic).
- **Data**: Sensor implementation, Settings storage.
- **Presentation**: UI components (Riverpod for state management).

## License
MIT
