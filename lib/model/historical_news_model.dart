class HistoricalNewsModel {
  final String title;
  final String description;
  final String url;
  final String image;
  final String publishedAt;
  final String source;
  final String category;

  HistoricalNewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.source,
    required this.category,
  });

  factory HistoricalNewsModel.fromJson(Map<String, dynamic> json) {
    return HistoricalNewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      publishedAt: json['published_at'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
