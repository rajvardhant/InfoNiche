// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/model/search_news_model.dart';
import 'package:news_app/repositry/news_repository.dart';
import 'package:news_app/controller/language_controller.dart';

class NewsViewModel {
  final _newsRepo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async {
    final response = await _newsRepo.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<categoriesNewsModel> fetchCategoriesNewsApi(String Category) async {
    final response = await _newsRepo.fetchCategoriesNewsApi(Category);
    return response;
  }

  Future<SearchNewsModel> searchNews(String query) async {
    final languageController = Get.find<LanguageController>();
    String url;
    
    if (languageController.currentLanguageCode == 'hi') {
      // For Hindi, search in Indian news
      url = 'https://newsapi.org/v2/everything?q=$query&country=in&apiKey=71c7931b65454f4092125f9860612404';
    } else {
      url = 'https://newsapi.org/v2/everything?q=$query&language=${languageController.currentLanguageCode}&apiKey=71c7931b65454f4092125f9860612404';
    }
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return SearchNewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search news');
    }
  }
}
