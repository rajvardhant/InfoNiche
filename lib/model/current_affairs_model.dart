class CurrentAffairsModel {
  final String title;
  final String description;
  final String date;

  CurrentAffairsModel({
    required this.title,
    required this.description,
    required this.date,
  });

  factory CurrentAffairsModel.fromJson(Map<String, dynamic> json) {
    return CurrentAffairsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
