import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'selectedLanguage';

  // Language codes for News API
  static const Map<String, String> languages = {
    'English': 'en',
    'Hindi': 'hi',
    'Spanish': 'es',
    'Chinese': 'zh',
    'Arabic': 'ar',
    'French': 'fr',
    'Russian': 'ru',
    'Japanese': 'ja',
  };

  String get currentLanguage => _box.read(_key) ?? 'English';
  String get currentLanguageCode => languages[currentLanguage] ?? 'en';

  void changeLanguage(String language) {
    if (languages.containsKey(language)) {
      _box.write(_key, language);
      update();
    }
  }
}
