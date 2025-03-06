import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/controller/language_controller.dart';
import 'package:news_app/controller/interest_controller.dart';

class NewsRepository {
  static const Map<String, String> languageToCountry = {
    'en': 'us',    // English -> United States
    'hi': 'in',    // Hindi -> India
    'es': 'es',    // Spanish -> Spain
    'zh': 'cn',    // Chinese -> China
    'ar': 'ae',    // Arabic -> UAE
    'fr': 'fr',    // French -> France
    'ru': 'ru',    // Russian -> Russia
    'ja': 'jp',    // Japanese -> Japan
  };

  String get languageCode {
    final languageController = Get.find<LanguageController>();
    return languageController.currentLanguageCode;
  }

  String get countryCode {
    return languageToCountry[languageCode] ?? 'us';
  }

  List<String> get userInterests {
    try {
      final interestController = Get.find<InterestController>();
      return interestController.selectedInterests;
    } catch (_) {
      return [];
    }
  }

  String _buildQueryFromInterests() {
    final interests = userInterests;
    if (interests.isEmpty) return '';
    
    // Combine interests with OR operator
    return interests.map((interest) => '"$interest"').join(' OR ');
  }

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    try {
      final interests = _buildQueryFromInterests();
      String baseUrl = 'https://newsapi.org/v2/top-headlines';
      Map<String, String> queryParams = {
        'apiKey': '71c7931b65454f4092125f9860612404',
        'pageSize': '100',
        'language': languageCode,
      };

      if (interests.isNotEmpty) {
        // If user has interests, use everything endpoint with q parameter
        baseUrl = 'https://newsapi.org/v2/everything';
        queryParams['q'] = interests;
        queryParams['sortBy'] = 'relevancy';
      } else {
        // Otherwise use top-headlines with country
        queryParams['country'] = countryCode;
      }

      if (channelName.isNotEmpty) {
        queryParams['sources'] = channelName;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      
      if (kDebugMode) {
        print('API URL: $uri');
      }

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = NewsChannelHeadlinesModel.fromJson(body);
        
        if (model.articles?.isNotEmpty == true) {
          return model;
        }
      }

      // Fallback to general news if no articles found
      final fallbackUrl = Uri.parse('$baseUrl?country=$countryCode&apiKey=71c7931b65454f4092125f9860612404');
      final fallbackResponse = await http.get(fallbackUrl);
      
      if (fallbackResponse.statusCode == 200) {
        final fallbackBody = jsonDecode(fallbackResponse.body);
        return NewsChannelHeadlinesModel.fromJson(fallbackBody);
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching news: $e');
      }
    }
    
    throw Exception('No news articles available at the moment. Please try again later.');
  }

  Future<categoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    try {
      final interests = _buildQueryFromInterests();
      String baseUrl = 'https://newsapi.org/v2/top-headlines';
      Map<String, String> queryParams = {
        'apiKey': '71c7931b65454f4092125f9860612404',
        'pageSize': '100',
        'language': languageCode,
        'category': category,
      };

      if (interests.isNotEmpty) {
        queryParams['q'] = interests;
      }
      queryParams['country'] = countryCode;

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      
      if (kDebugMode) {
        print('Category API URL: $uri');
      }

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = categoriesNewsModel.fromJson(body);
        
        if (model.articles?.isNotEmpty == true) {
          return model;
        }
      }

      // If no articles found, try without interests filter
      final fallbackUrl = Uri.parse('$baseUrl?country=$countryCode&category=$category&pageSize=100&apiKey=71c7931b65454f4092125f9860612404');
      final fallbackResponse = await http.get(fallbackUrl);
      
      if (fallbackResponse.statusCode == 200) {
        final fallbackBody = jsonDecode(fallbackResponse.body);
        return categoriesNewsModel.fromJson(fallbackBody);
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching category news: $e');
      }
    }
    
    throw Exception('Failed to load category news. Please try again later.');
  }
}
