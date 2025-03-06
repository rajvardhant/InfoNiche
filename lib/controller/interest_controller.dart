import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class InterestController extends GetxController {
  final _box = GetStorage();
  final _hasSelectedInterests = 'hasSelectedInterests';
  final _selectedInterests = 'selectedInterests';

  static const Map<String, List<String>> programmingCategories = {
    'Web Development': [
      'Frontend Development',
      'Backend Development',
      'Full Stack Development',
      'Web Frameworks',
    ],
    'Mobile Development': [
      'Android Development',
      'iOS Development',
      'Flutter',
      'React Native',
    ],
    'Programming Languages': [
      'Python',
      'JavaScript',
      'Java',
      'C++',
      'Dart',
      'Kotlin',
      'Swift',
    ],
    'Data & AI': [
      'Machine Learning',
      'Data Science',
      'Artificial Intelligence',
      'Big Data',
    ],
    'DevOps & Cloud': [
      'Cloud Computing',
      'Docker',
      'Kubernetes',
      'CI/CD',
    ],
    'Other Tech': [
      'Cybersecurity',
      'Blockchain',
      'IoT',
      'Game Development',
    ],
  };

  bool get hasSelectedInterests => _box.read(_hasSelectedInterests) ?? false;
  List<String> get selectedInterests => 
      List<String>.from(_box.read(_selectedInterests) ?? []);

  void saveInterests(List<String> interests) {
    _box.write(_hasSelectedInterests, true);
    _box.write(_selectedInterests, interests);
    update();
  }

  void resetInterests() {
    _box.write(_hasSelectedInterests, false);
    _box.write(_selectedInterests, []);
    update();
  }
}
