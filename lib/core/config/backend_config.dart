import 'package:flutter/foundation.dart';

/// Configuration dynamique de l'adresse du backend.
///
/// Sur un émulateur Android, `127.0.0.1` pointe vers l'émulateur lui-même.
/// L'adresse spéciale `10.0.2.2` est redirigée vers le PC hôte.
class BackendConfig {
  BackendConfig._();

  static String get baseUrl {
    // Valeur fournie à la compilation via --dart-define
    const envUrl = String.fromEnvironment('BACKEND_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // Détection automatique de la plateforme
    if (kIsWeb) {
      return 'http://127.0.0.1:8001';
    }
    // Sur Android natif, l'émulateur utilise 10.0.2.2 pour joindre le host
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8001';
    }
    // iOS, macOS, Windows, Linux
    return 'http://127.0.0.1:8001';
  }

  static Uri chatUri() => Uri.parse('$baseUrl/chat/');
  static Uri recommendUri() => Uri.parse('$baseUrl/recommend/');
  static Uri modelStatusUri() => Uri.parse('$baseUrl/model/status');
}
