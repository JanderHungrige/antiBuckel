import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isServiceRunning = false;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
    _requestPermissions();
  }

  Future<void> _checkServiceStatus() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
      Permission.accessNotificationPolicy, // For DND/Volume if needed?
    ].request();
  }

  Future<void> _toggleService() async {
    final service = FlutterBackgroundService();
    if (_isServiceRunning) {
      service.invoke('stopService');
    } else {
      await service.startService();
    }
    
    // Give time for service to start/stop
    await Future.delayed(const Duration(seconds: 1));
    _checkServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    final angleAsync = ref.watch(currentAngleProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AntiBuckel Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _isServiceRunning ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isServiceRunning ? Colors.green : Colors.red),
              ),
              child: Text(
                _isServiceRunning ? "MONITORING ACTIVE" : "MONITORING STOPPED",
                style: TextStyle(
                  color: _isServiceRunning ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Angle Visualizer
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                  ),
                  angleAsync.when(
                    data: (angle) {
                      // Normalize angle for display (0 is horizontal usually, but our logic uses pitch)
                      // Let's just display the number.
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: (angle - 90) * pi / 180, // Rotate needle to match vertical being 90
                            child: const Icon(Icons.arrow_upward, size: 50, color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${angle.toStringAsFixed(1)}°",
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const Text("Pitch", style: TextStyle(color: Colors.white54)),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, _) => Text("Error: $err"),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Start/Stop Button
            ElevatedButton.icon(
              onPressed: _toggleService,
              icon: Icon(_isServiceRunning ? Icons.stop : Icons.play_arrow),
              label: Text(_isServiceRunning ? "STOP MONITORING" : "START MONITORING"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: _isServiceRunning ? Colors.redAccent : Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
