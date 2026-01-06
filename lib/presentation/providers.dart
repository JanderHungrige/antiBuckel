import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/sensor_service.dart';
import '../../data/repositories/settings_repository.dart';

final sensorServiceProvider = Provider<SensorService>((ref) {
  return SensorService();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final currentAngleProvider = StreamProvider<double>((ref) {
  final service = ref.watch(sensorServiceProvider);
  service.startListening(); // Ensure listening
  ref.onDispose(() => service.stopListening());
  return service.pitchStream;
});
