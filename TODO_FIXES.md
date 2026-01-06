# 🛠️ App Fixes & Enhancements (feature/app-fixes)

This document tracks technical debt, bugs, and UX improvements identified following the MVP/Phase 6 release.

## 1. Calibration & Angle Logic
- [ ] **Calibration Re-triggering**: The "Calibrate" button works once but fails to reset or re-calibrate on subsequent taps.
- [ ] **Angle Intuition (90° Scale)**: Current "straight up" position reports ~55°. Adjust calculation so vertical orientation equals 90° for better user mapping.
- [ ] **Threshold Offset Bug**: Changing settings (tolerance/target) causes deviations in detection accuracy. Defaults work, but custom ranges feel "off".
- [ ] **Axis Selector**: 
    - Add setting to choose which axes are monitored (Pitch and roll vs. Roll vs. Pitch).
    - Allow isolation of "away from user" tilt (Pitch) while ignoring rotation/flatness (Roll) for specific use cases (e.g., sitting vs. watching movies).

## 2. Background Service & Settings
- [ ] **Reactive Settings**: 
    - Changes in settings do not apply until the service is manually stopped and restarted.
    - *Proposed Fix*: Implement a listener in the background service to reload configuration live, or automatically restart the service when settings are saved.
- [ ] **Background Persistence (Debug Mode)**: 
    - Minimize app in debug mode stops monitoring. Verify if this is a Flutter debugger limitation or a genuine background execution failure on iOS/Android.

## 3. UI/UX & Brand
- [ ] **Pitch Indicator**: Update the main dashboard to show the **actual real-time angle** numeric value alongside the color indicator.
- [ ] **App Icon Polish**:
    - Fix white bars (top/bottom) in the current icon.
    - Replace pixelated assets with high-resolution versions.
    - Ensure full-bleed icon coverage for both platforms.
- [ ] **Documentation**:
    - Embed the background image (`humpback.jpg`) into the `README.md` for visual effekt under the initial headline.

## 4. Technical Investigation
- [ ] Investigate why the pitch/roll calculation drifts or feels inaccurate when the target angle is not 90°.

## 5. Smart eye tracking
- [ ] use the builtin eye tracking of the phone to detect if the user is looking at the phone or not. and only trigger the alarm if the user is looking at the phone.
- [ ] add a switch to enable or disable this feature. set it default to enabled.
