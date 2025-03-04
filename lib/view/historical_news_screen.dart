import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/historical_news_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoricalNewsScreen extends StatelessWidget {
  final controller = Get.put(HistoricalNewsController());
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historical News'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Select Date (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        dateController.text = 
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (dateController.text.isNotEmpty) {
                      controller.fetchHistoricalNews(date: dateController.text);
                    }
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.historicalNews.isEmpty) {
                return Center(child: Text('No historical news found'));
              }

              return ListView.builder(
                itemCount: controller.historicalNews.length,
                itemBuilder: (context, index) {
                  final news = controller.historicalNews[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: news.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: news.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          : null,
                      title: Text(news.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(news.description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4),
                          Text(
                            '${news.source} • ${news.category} • ${news.publishedAt}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Implement news detail view
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
