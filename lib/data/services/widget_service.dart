import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _androidWidgetName = 'BuckelWidget';
  // iOS requires Group ID for sharing data
  static const String _iOSGroupId = 'group.com.example.antibuckel'; 

  Future<void> updateWidgetStatus(bool isRunning) async {
    await HomeWidget.saveWidgetData<bool>('is_running', isRunning);
    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      iOSName: _androidWidgetName,
      qualifiedAndroidName: 'com.example.antibuckel.BuckelWidget',
    );
  }
}
