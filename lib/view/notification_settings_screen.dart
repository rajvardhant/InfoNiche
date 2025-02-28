import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  String _selectedNotificationOption = 'all';

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedNotificationOption =
          prefs.getString('notification_settings') ?? 'all';
    });
  }

  Future<void> _saveNotificationSettings(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', value);
    setState(() {
      _selectedNotificationOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your notification preferences',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            _buildNotificationOption(
              'All Notifications',
              'Receive all news updates and alerts',
              'all',
            ),
            const Divider(),
            _buildNotificationOption(
              'Scheduled Notifications',
              'Receive notifications at scheduled times',
              'scheduled',
            ),
            const Divider(),
            _buildNotificationOption(
              'No Notifications',
              'Turn off all notifications',
              'none',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption(String title, String subtitle, String value) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 14,
        ),
      ),
      value: value,
      groupValue: _selectedNotificationOption,
      onChanged: (String? newValue) {
        if (newValue != null) {
          _saveNotificationSettings(newValue);
        }
      },
    );
  }
}
