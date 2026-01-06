import 'package:vibration/vibration.dart';
import 'package:screen_brightness/screen_brightness.dart';
// import 'package:audioplayers/audioplayers.dart'; // Commented out for now until asset is ready

class NotificationService {
  // Simple throttle to prevent spamming hardware calls
  DateTime? _lastVibrate;
  
  Future<void> triggerAlarm({
    required double intensity, 
    required bool vibrateEnabled, 
    required bool soundEnabled, 
    required bool brightnessEnabled
  }) async {
    // 1. Vibration
    if (vibrateEnabled) {
      final now = DateTime.now();
      if (_lastVibrate == null || now.difference(_lastVibrate!) > const Duration(milliseconds: 500)) {
        bool hasVib = await Vibration.hasVibrator() ?? false;
        if (hasVib) {
           // Intensity 0.0-1.0. Map to amplitude 1-255?
           // Vibration package support for amplitude varies.
           // Simple fallback: duration based on intensity?
           // Or just standard vibrate for now.
           
           int duration = (100 + (intensity * 400)).toInt(); // 100ms to 500ms
           Vibration.vibrate(duration: duration);
           _lastVibrate = now;
        }
      }
    }

    // 2. Brightness
    if (brightnessEnabled) {
      // Dimming: 1.0 (Bright) -> 0.0 (Dark).
      // If alarm is high (intensity 1.0), brightness should be low.
      // Assuming user wants dimming as penalty/reminder.
      // So brightness = 1.0 - intensity.
      // Min brightness shouldn't be 0 (black screen), maybe 0.1.
      double targetBrightness = 1.0 - (intensity * 0.9);
      try {
        await ScreenBrightness().setScreenBrightness(targetBrightness);
      } catch (e) {
        print("Brightness error: $e");
      }
    } else {
       // Reset brightness? Or leave it?
       // Ideally we should reset it when state is GOOD.
       // This function is "triggerAlarm", implied bad state.
    }
    
    // 3. Sound
    if (soundEnabled) {
      // TODO: Implement sound player with intensity-based volume or pitch
    }
  }

  Future<void> resetAlarms() async {
    // Stop vibration
    Vibration.cancel();
    
    // Reset brightness
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
       // ignore
    }
  }
}
