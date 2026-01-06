import '../entities/angle_config.dart';
import '../entities/posture_state.dart';

class TiltResult {
  final PostureState state;
  final double intensity; // 0.0 to 1.0

  TiltResult(this.state, this.intensity);
}

class TiltLogic {
  TiltResult calculateState(double currentAngle, AngleConfig config) {
    // Normalizing angle mostly for safety, though sensors_plus usually gives -180 to 180 or similar.
    // Assuming input is -90 to 90 or 0 to 180 for pitch.
    // SensorService calculates atan2(y, z), resulting in -180 to 180.
    // Vertical phone ~ 90 degrees.
    // Flat on table ~ 0 degrees.
    
    double diff = (currentAngle - config.targetAngle).abs();

    if (diff <= config.tolerance) {
      return TiltResult(PostureState.good, 0.0);
    } else {
      // Outside tolerance.
      // Define a "max alarm range" beyond tolerance, e.g. another 20 degrees.
      const double alarmRange = 30.0; // Hardcoded for now, or could be in config.
      
      double excess = diff - config.tolerance;
      double intensity = (excess / alarmRange).clamp(0.0, 1.0);
      
      return TiltResult(PostureState.bad, intensity);
    }
  }
}
