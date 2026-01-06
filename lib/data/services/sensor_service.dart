import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final _pitchController = StreamController<double>.broadcast();

  Stream<double> get pitchStream => _pitchController.stream;

  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Calculate pitch (rotation around X-axis)
      // Standard formula: atan2(y, z) or atan2(y, sqrt(x*x + z*z))
      // Returning degrees.
      double pitch = atan2(event.y, event.z) * 180 / pi;
      _pitchController.add(pitch);
    });
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }
}
