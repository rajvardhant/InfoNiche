import 'package:http/http.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/repositry/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi() async {
    final response = await _rep.fetchNewChannelHeadLinesApi();
    return response;
  }
}
