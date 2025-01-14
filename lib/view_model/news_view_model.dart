import 'package:http/http.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/repositry/news_repository.dart';

class NewsViewModel {
  final _newsRepo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async {
    final response = await _newsRepo.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }
}
