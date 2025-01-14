import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=71c7931b65454f4092125f9860612404';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('API Response: ${response.body}');
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception(
        'Error fetching news for $channelName: Status ${response.statusCode}');
  }

  Future<categoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=71c7931b65454f4092125f9860612404';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('API Response: ${response.body}');
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return categoriesNewsModel.fromJson(body);
    }
    throw Exception('Error, News is not fetching from API');
  }
}
