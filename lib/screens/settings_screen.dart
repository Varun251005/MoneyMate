import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _currency = '₹ INR';
  String _username = '';
  String _profileImagePath = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _darkMode = prefs.getBool('darkMode') ?? false;
      _profileImagePath = prefs.getString('profileImagePath') ?? '';
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', image.path);
        setState(() {
          _profileImagePath = image.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[100],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: _profileImagePath.isEmpty
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF1FA7A8),
                                    Color(0xFF15858A),
                                  ],
                                )
                              : null,
                        ),
                        child: _profileImagePath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(
                                  File(_profileImagePath),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username.isNotEmpty
                                ? _username
                                : 'Money Mate User',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to change profile picture',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Preferences Section
            Text(
              'Preferences',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              'Notifications',
              'Enable payment reminders',
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
              },
              isDarkMode,
            ),
            const SizedBox(height: 12),
            _buildSettingCard('Dark Mode', 'Use dark theme', _darkMode, (
              value,
            ) {
              setState(() => _darkMode = value);
              MoneyMateApp.of(context)?.toggleTheme();
            }, isDarkMode),
            const SizedBox(height: 28),

            // App Settings Section
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionCard('Currency', _currency, () {
              _showCurrencyDialog();
            }, isDarkMode),
            const SizedBox(height: 28),

            // About Section
            Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard('Developer', 'Varun', isDarkMode),
            const SizedBox(height: 28),

            // Danger Zone
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showDeleteDialog();
                },
                child: const Text(
                  'Clear All Data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    bool isDarkMode,
  ) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        splashColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: subtitleColor),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1FA7A8),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String value,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final valueColor = isDarkMode ? Colors.white54 : Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        splashColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(color: valueColor)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: valueColor),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final valueColor = isDarkMode ? Colors.white54 : Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        splashColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        trailing: Text(value, style: TextStyle(color: valueColor)),
      ),
    );
  }

  void _showCurrencyDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Currency', style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              splashColor: Colors.transparent,
              title: Text('₹ INR', style: TextStyle(color: textColor)),
              onTap: () {
                setState(() => _currency = '₹ INR');
                Navigator.pop(context);
              },
            ),
            ListTile(
              splashColor: Colors.transparent,
              title: Text('\$ USD', style: TextStyle(color: textColor)),
              onTap: () {
                setState(() => _currency = '\$ USD');
                Navigator.pop(context);
              },
            ),
            ListTile(
              splashColor: Colors.transparent,
              title: Text('€ EUR', style: TextStyle(color: textColor)),
              onTap: () {
                setState(() => _currency = '€ EUR');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data?', style: TextStyle(color: textColor)),
        content: Text(
          'This action cannot be undone. All your transactions and EMI data will be permanently deleted.',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
