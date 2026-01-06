import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Optional for visible notification
import 'sensor_service.dart';
import 'notification_service.dart';
import '../repositories/settings_repository.dart';
import '../../domain/logic/tilt_logic.dart';
import '../../domain/entities/posture_state.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Android Notification
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'antibuckel_service', // id
    'BuckelFips Service', // title
    description: 'Monitoring posture in background',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'antibuckel_service',
      initialNotificationTitle: 'BuckelFips Active',
      initialNotificationContent: 'Monitoring your posture...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Ensure bindings
  DartPluginRegistrant.ensureInitialized();

  // Dependencies
  final sensorService = SensorService();
  final settingsRepo = SettingsRepository();
  final tiltLogic = TiltLogic();
  final notificationService = NotificationService();
  
  // Load initial config
  var angleConfig = await settingsRepo.getAngleConfig();
  var alarmConfig = await settingsRepo.getAlarmConfig();

  // Listen to UI updates
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('updateSettings').listen((event) async {
    angleConfig = await settingsRepo.getAngleConfig();
    alarmConfig = await settingsRepo.getAlarmConfig();
  });

  // Start logic
  sensorService.startListening();
  
  sensorService.pitchStream.listen((pitch) async {
    // Logic
    final result = tiltLogic.calculateState(pitch, angleConfig);
    
    if (result.state == PostureState.bad) {
       await notificationService.triggerAlarm(
         intensity: result.intensity,
         vibrateEnabled: alarmConfig['vibrate'] ?? true,
         soundEnabled: alarmConfig['sound'] ?? false,
         brightnessEnabled: alarmConfig['brightness'] ?? true,
       );
    } else {
       // Reset alarms? Or just stop triggering?
       // Ideally verify if we need to reset brightness
       // For now, notification service handles "stateful" alarms (like sound looping) if we implemented loop.
       // But we implemented impulse vibration.
    }
    
    if (service is AndroidServiceInstance) {
       if (await service.isForegroundService()) {
          // Update notification content?
          // service.setForegroundNotificationInfo(...)
       }
    }
  });
}
