import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Language',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GetBuilder<LanguageController>(
        builder: (controller) => ListView.builder(
          itemCount: LanguageController.languages.length,
          itemBuilder: (context, index) {
            final language = LanguageController.languages.keys.elementAt(index);
            return ListTile(
              title: Text(
                language,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: controller.currentLanguage == language
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              leading: Radio<String>(
                value: language,
                groupValue: controller.currentLanguage,
                onChanged: (String? value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                    Get.snackbar(
                      'Language Changed',
                      'News will now be shown in $value',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
              trailing: controller.currentLanguage == language
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            );
          },
        ),
      ),
    );
  }
}
