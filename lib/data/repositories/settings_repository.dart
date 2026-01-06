import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/angle_config.dart';

class SettingsRepository {
  static const String _keyTargetAngle = 'target_angle';
  static const String _keyTolerance = 'tolerance';
  static const String _keyVibrate = 'alarm_vibrate';
  static const String _keySound = 'alarm_sound';
  static const String _keyBrightness = 'alarm_brightness';

  Future<void> saveAngleConfig(AngleConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTargetAngle, config.targetAngle);
    await prefs.setDouble(_keyTolerance, config.tolerance);
  }

  Future<AngleConfig> getAngleConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return AngleConfig(
      targetAngle: prefs.getDouble(_keyTargetAngle) ?? 90.0,
      tolerance: prefs.getDouble(_keyTolerance) ?? 20.0,
    );
  }

  Future<void> setAlarmEnabled(String type, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == 'vibrate') await prefs.setBool(_keyVibrate, enabled);
    if (type == 'sound') await prefs.setBool(_keySound, enabled);
    if (type == 'brightness') await prefs.setBool(_keyBrightness, enabled);
  }

  Future<Map<String, bool>> getAlarmConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'vibrate': prefs.getBool(_keyVibrate) ?? true,
      'sound': prefs.getBool(_keySound) ?? false,
      'brightness': prefs.getBool(_keyBrightness) ?? true,
    };
  }
}
