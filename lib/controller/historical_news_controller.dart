import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/historical_news_model.dart';

class HistoricalNewsController extends GetxController {
  static const String apiKey = '56166ce2efb7affa23bb038e3db1bdc0';
  var isLoading = false.obs;
  var historicalNews = <HistoricalNewsModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchHistoricalNews({
    required String date,
    String? categories,
    String? countries,
    String? languages,
    int limit = 100,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final queryParams = {
        'access_key': apiKey,
        'date': date,
        if (categories != null) 'categories': categories,
        if (countries != null) 'countries': countries,
        if (languages != null) 'languages': languages,
        'limit': limit.toString(),
      };

      final uri = Uri.http('api.mediastack.com', '/v1/news', queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          historicalNews.value = (data['data'] as List)
              .map((item) => HistoricalNewsModel.fromJson(item))
              .toList();
        }
      } else {
        errorMessage.value = 'Failed to fetch historical news';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
