// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/repositry/news_repository.dart';

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


}
