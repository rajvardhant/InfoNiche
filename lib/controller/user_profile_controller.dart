import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileController extends GetxController {
  final _box = GetStorage();
  final _hasSetupProfile = 'hasSetupProfile';
  final _userName = 'userName';
  final _userGender = 'userGender';
  final _userProfileImage = 'userProfileImage';

  bool get hasSetupProfile => _box.read(_hasSetupProfile) ?? false;
  String get userName => _box.read(_userName) ?? '';
  String get userGender => _box.read(_userGender) ?? 'male';
  String? get profileImagePath => _box.read(_userProfileImage);

  final _imagePicker = ImagePicker();

  void saveProfile({required String name, required String gender}) {
    _box.write(_hasSetupProfile, true);
    _box.write(_userName, name);
    _box.write(_userGender, gender.toLowerCase());
    update();
  }

  void updateName(String name) {
    _box.write(_userName, name);
    update();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        _box.write(_userProfileImage, image.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeProfileImage() {
    _box.remove(_userProfileImage);
    update();
  }

  void resetProfile() {
    _box.write(_hasSetupProfile, false);
    _box.write(_userName, '');
    _box.write(_userGender, 'male');
    _box.remove(_userProfileImage);
    update();
  }
}
