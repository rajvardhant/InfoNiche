import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../controller/theme_controller.dart';
import '../controller/language_controller.dart';
import '../controller/user_profile_controller.dart';
import 'feedback_screen.dart';
import 'notification_settings_screen.dart';
import 'static_page.dart';
import 'language_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(BuildContext context, UserProfileController controller) {
    final TextEditingController nameController = TextEditingController(text: controller.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Name',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                controller.updateName(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context, UserProfileController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Profile Picture',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor),
              ),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
              ),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
              },
            ),
            if (controller.profileImagePath != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Remove photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  controller.removeProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, UserProfileController controller) {
    final isDark = Get.isDarkMode;
    return GestureDetector(
      onTap: () => _showImagePickerDialog(context, controller),
      child: Stack(
        children: [
          Hero(
            tag: 'profile_image',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.2)
                      : Theme.of(context).primaryColor.withOpacity(0.2),
                  width: 4,
                ),
                image: controller.profileImagePath != null
                    ? DecorationImage(
                        image: FileImage(File(controller.profileImagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: controller.profileImagePath == null
                    ? (isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).colorScheme.secondary.withOpacity(0.1))
                    : null,
              ),
              child: controller.profileImagePath == null
                  ? Icon(
                      controller.userGender == 'female' ? Icons.face_3 : Icons.face_6,
                      size: 60,
                      color: isDark ? Colors.white : Theme.of(context).colorScheme.secondary,
                    )
                  : null,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    final isDark = Get.isDarkMode;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Colors.grey[850] : Colors.grey[100],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : (iconColor ?? Get.theme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark
                ? Colors.white
                : (iconColor ?? Get.theme.primaryColor),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final LanguageController languageController = Get.put(LanguageController());
    final userController = Get.find<UserProfileController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).primaryColor.withOpacity(0.15)
                    : Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: GetBuilder<UserProfileController>(
                builder: (controller) => Column(
                  children: [
                    _buildProfileImage(context, controller),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditNameDialog(context, controller),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                    ),
                  ),
                  GetBuilder<ThemeController>(
                    builder: (controller) => _buildSettingsTile(
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      onTap: () => controller.toggleTheme(),
                      trailing: Switch(
                        value: controller.isDarkMode,
                        onChanged: (value) => controller.toggleTheme(),
                      ),
                    ),
                  ),
                  GetBuilder<LanguageController>(
                    builder: (controller) => _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LanguageScreen()),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.currentLanguage,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      'Support',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Implement help & support
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.star,
                    title: 'Feedback',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.contact_support,
                    title: 'Contact Us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaticPage(
                          title: 'Contact Us',
                          content: 'Email: support@newsapp.com\n\nPhone: +91 1234567890\n\nAddress: Patna, Bihar, India',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      'Legal',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaticPage(
                          title: 'Privacy Policy',
                          content: 'Our Privacy Policy explains how we collect, use, and protect your personal information when you use our news app...',
                        ),
                      ),
                    ),
                  ),
                  _buildSettingsTile(
                    icon: Icons.description,
                    title: 'Terms & Conditions',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaticPage(
                          title: 'Terms & Conditions',
                          content: 'By using our news app, you agree to these terms and conditions...',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsTile(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    iconColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text(
                            'Delete Account',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.clear();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
