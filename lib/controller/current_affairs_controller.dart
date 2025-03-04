import 'package:get/get.dart';
import '../model/current_affairs_model.dart';
import '../repositry/current_affairs_repository.dart';

class CurrentAffairsController extends GetxController {
  final CurrentAffairsRepository repository = CurrentAffairsRepository();
  final RxList<CurrentAffairsModel> currentAffairs = <CurrentAffairsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentAffairs();
  }

  Future<void> fetchCurrentAffairs() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await repository.getCurrentAffairs();
      currentAffairs.assignAll(data);
    } catch (e) {
      error.value = 'Failed to load historical events: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
