import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/current_affairs_model.dart';

class CurrentAffairsRepository {
  final String apiUrl = "https://current-affairs-of-india.p.rapidapi.com/history-of-today";
  final Map<String, String> headers = {
    "x-rapidapi-key": "ce5fa8145fmsh9695265905e642bp1ca9cfjsnd0a1d6c2b03e",
    "x-rapidapi-host": "current-affairs-of-india.p.rapidapi.com",
  };

  Future<List<CurrentAffairsModel>> getCurrentAffairs() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        return data.map((item) => CurrentAffairsModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load current affairs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching current affairs: $e');
    }
  }
}
