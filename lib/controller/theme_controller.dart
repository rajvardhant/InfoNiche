import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool get isDarkMode => _box.read(_key) ?? false;

  void toggleTheme() {
    _box.write(_key, !isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    update();
  }

  void initTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
