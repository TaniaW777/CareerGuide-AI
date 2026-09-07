import 'dart:convert';
import 'package:http/http.dart' as http;

/// Backend injoignable : pas de réseau, serveur arrêté ou timeout dépassé.
class BackendUnavailableException implements Exception {
  final String message;
  BackendUnavailableException(this.message);

  @override
  String toString() => message;
}

/// Le backend a répondu, mais avec un statut ou un contenu invalide.
class BackendResponseException implements Exception {
  final String message;
  BackendResponseException(this.message);

  @override
  String toString() => message;
}

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

  /// Timeout volontairement court : hors connexion, l'application bascule
  /// rapidement sur les recommandations locales de secours.
  static const Duration _timeout = Duration(seconds: 3);

  Future<List<Map<String, dynamic>>> getRecommendations({
    required String level,
    required String series,
    required List<String> subjects,
    required String interest,
  }) async {
    final http.Response response;
    try {
      response = await http
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
          .timeout(_timeout);
    } on Exception {
      // Timeout, résolution DNS ou connexion refusée : transport impossible.
      throw BackendUnavailableException('Backend injoignable ($_baseUrl)');
    }

    if (response.statusCode != 200) {
      throw BackendResponseException('Erreur serveur ${response.statusCode}');
    }

    try {
      final data = jsonDecode(response.body);
      return (data["recommendations"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      throw BackendResponseException('Réponse invalide : $e');
    }
  }
}
