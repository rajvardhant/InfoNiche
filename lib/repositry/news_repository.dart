import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/controller/language_controller.dart';

class NewsRepository {
  static const Map<String, String> languageToCountry = {
    'en': 'us',    // English -> United States
    'hi': 'in',    // Hindi -> India
    'fr': 'fr',    // French -> France
    'es': 'es',    // Spanish -> Spain
    'de': 'de',    // German -> Germany
  };

  String get languageCode {
    final languageController = Get.find<LanguageController>();
    return languageController.currentLanguageCode;
  }

  String get countryCode {
    return languageToCountry[languageCode] ?? 'us';
  }

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    String url;
    
    if (languageCode == 'hi') {
      // For Hindi, fetch Indian news
      url = 'https://newsapi.org/v2/top-headlines?country=in&pageSize=100&apiKey=71c7931b65454f4092125f9860612404';
    } else {
      // For other languages
      url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&language=$languageCode&apiKey=71c7931b65454f4092125f9860612404';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) {
        print('API URL: $url');
        print('API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = NewsChannelHeadlinesModel.fromJson(body);
        
        if (model.articles?.isNotEmpty == true) {
          return model;
        }
        
        // If no articles found, try country-based news
        String fallbackUrl = 'https://newsapi.org/v2/top-headlines?country=$countryCode&apiKey=71c7931b65454f4092125f9860612404';
        final fallbackResponse = await http.get(Uri.parse(fallbackUrl));
        
        if (fallbackResponse.statusCode == 200) {
          final fallbackBody = jsonDecode(fallbackResponse.body);
          return NewsChannelHeadlinesModel.fromJson(fallbackBody);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching news: $e');
      }
    }
    
    throw Exception('No news articles available at the moment. Please try again later.');
  }

  Future<categoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url;
    
    if (languageCode == 'hi') {
      // For Hindi categories
      url = 'https://newsapi.org/v2/top-headlines?country=in&category=$category&pageSize=100&apiKey=71c7931b65454f4092125f9860612404';
    } else {
      // For other languages
      url = 'https://newsapi.org/v2/top-headlines?country=$countryCode&category=$category&language=$languageCode&apiKey=71c7931b65454f4092125f9860612404';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) {
        print('Category API URL: $url');
        print('Category API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return categoriesNewsModel.fromJson(body);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching category news: $e');
      }
    }
    
    throw Exception('Failed to load category news. Please try again later.');
  }
}
