import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkController extends GetxController {
  final storage = GetStorage();
  final bookmarkedNews = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    final savedBookmarks = storage.read<List>('bookmarks') ?? [];
    bookmarkedNews.value = List<Map<String, dynamic>>.from(savedBookmarks);
  }

  void toggleBookmark(Map<String, dynamic> newsItem) {
    final exists = bookmarkedNews.any((item) => item['newsTitle'] == newsItem['newsTitle']);
    
    if (exists) {
      bookmarkedNews.removeWhere((item) => item['newsTitle'] == newsItem['newsTitle']);
    } else {
      bookmarkedNews.add(newsItem);
    }
    
    storage.write('bookmarks', bookmarkedNews.toList());
  }

  bool isBookmarked(String newsTitle) {
    return bookmarkedNews.any((item) => item['newsTitle'] == newsTitle);
  }
}
