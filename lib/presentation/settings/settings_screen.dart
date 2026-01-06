import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/angle_config.dart';
import '../providers.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Local state
  Map<String, bool> _alarms = {
    'vibrate': true,
    'sound': false,
    'brightness': true,
  };
  double _targetAngle = 90.0;
  double _tolerance = 20.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final angleConfig = await repo.getAngleConfig();
    final alarms = await repo.getAlarmConfig();

    if (mounted) {
      setState(() {
        _targetAngle = angleConfig.targetAngle;
        _tolerance = angleConfig.tolerance;
        _alarms = alarms;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveAngleConfig(AngleConfig(targetAngle: _targetAngle, tolerance: _tolerance));
    
    // Save alarms
    for (var entry in _alarms.entries) {
      await repo.setAlarmEnabled(entry.key, entry.value);
    }
    
    // Notify Service to reload?
    // Using flutter_background_service invoke
    // But we need to import it.
    // Ideally use a stream.
    // For now we assume service reloads on next check or we invoke explicitly.
    // In BackgroundService we listened to 'updateSettings'.
    
    // Verify service is running before invoking? Invoke is safe even if not running usually (just ignored).
    FlutterBackgroundService().invoke('updateSettings');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings Saved')),
      );
    }
  }
  
  void _calibrate() {
    // Read current angle from provider
    // This is a snapshot.
    final angleAsync = ref.read(currentAngleProvider);
    angleAsync.whenData((angle) {
      setState(() {
        _targetAngle = angle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Calibration", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            title: Text("Target Angle: ${_targetAngle.toStringAsFixed(1)}°"),
            subtitle: const Text("Hold phone in good posture and tap Calibrate"),
            trailing: ElevatedButton(
              onPressed: _calibrate,
              child: const Text("Calibrate"),
            ),
          ),
          const Divider(),
          
          const Text("Tolerance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Allowable tilt (+/-): ${_tolerance.toInt()}°"),
          Slider(
            value: _tolerance,
            min: 5.0,
            max: 45.0,
            divisions: 8,
            label: "${_tolerance.toInt()}°",
            onChanged: (val) {
              setState(() {
                _tolerance = val;
              });
            },
          ),
          const Divider(),

          const Text("Alarms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Vibration"),
            value: _alarms['vibrate'] ?? true,
            onChanged: (val) => setState(() => _alarms['vibrate'] = val),
          ),
          SwitchListTile(
            title: const Text("Sound"),
            value: _alarms['sound'] ?? false,
            onChanged: (val) => setState(() => _alarms['sound'] = val),
          ),
          SwitchListTile(
            title: const Text("Screen Dimming"),
            value: _alarms['brightness'] ?? true,
            onChanged: (val) => setState(() => _alarms['brightness'] = val),
          ),
          
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Save Settings"),
          ),
        ],
      ),
    );
  }
}
