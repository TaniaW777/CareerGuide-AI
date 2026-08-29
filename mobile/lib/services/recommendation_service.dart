import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static const String _baseUrl = "http://192.168.100.42:8000";

  Future<List<Map<String, dynamic>>> getRecommendations({
    required String level,
    required String series,
    required List<String> subjects,
    required String interest,
  }) async {
    final response = await http
        .post(
          Uri.parse("$_baseUrl/recommend/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "level": level,
            "series": series,
            "subjects": subjects,
            "interest": interest,
          }),
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["recommendations"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    throw Exception("Erreur serveur ${response.statusCode}");
  }
}