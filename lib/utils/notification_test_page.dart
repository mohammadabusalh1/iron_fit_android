import 'package:flutter/material.dart';
import 'package:iron_fit/utils/notification_test.dart';

class NotificationTestPage extends StatelessWidget {
  const NotificationTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Use this page to test notifications on your device',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              NotificationTestWidget(),
              const SizedBox(height: 24),
              const Text(
                'Troubleshooting Tips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTroubleshootingTip(
                '1. Check device settings',
                'Make sure notifications are enabled for this app in your device settings.',
              ),
              _buildTroubleshootingTip(
                '2. App permissions',
                'Verify that the app has necessary permissions for notifications.',
              ),
              _buildTroubleshootingTip(
                '3. Do Not Disturb',
                'Check if Do Not Disturb mode is enabled on your device.',
              ),
              _buildTroubleshootingTip(
                '4. iOS Focus Mode',
                'Check if Focus mode is filtering out notifications.',
              ),
              _buildTroubleshootingTip(
                '5. Background App Refresh',
                'For iOS, ensure Background App Refresh is enabled for this app.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTroubleshootingTip(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }
} 