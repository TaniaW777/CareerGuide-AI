import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  /// URL du backend, configurable à la compilation :
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000
  ///   flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
  ///
  /// Valeur par défaut : 10.0.2.2 = localhost de la machine hôte depuis
  /// l'émulateur Android. Pour un appareil physique, fournir l'adresse LAN
  /// du développeur via --dart-define.
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

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