import 'package:flutter/foundation.dart';
import 'platform_environment.dart' if (dart.library.io) 'platform_environment_io.dart';

/// Configuration dynamique de l'adresse du backend.
///
/// Sur un émulateur Android, `127.0.0.1` pointe vers l'émulateur lui-même.
/// L'adresse spéciale `10.0.2.2` est redirigée vers le PC hôte.
class BackendConfig {
  BackendConfig._();

  static const bool _isFlutterTest = bool.fromEnvironment('FLUTTER_TEST');

  static bool get _isRunningFlutterTest {
    if (_isFlutterTest) return true;
    return isFlutterTest;
  }

  static String get baseUrl {
    // Valeur fournie à la compilation via --dart-define
    const envUrl = String.fromEnvironment('BACKEND_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // In tests, always use localhost so VM-based integration tests target the host backend.
    if (_isRunningFlutterTest) {
      return 'http://127.0.0.1:8000';
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    // Sur Android natif, l'émulateur utilise 10.0.2.2 pour joindre le host
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    // iOS, macOS, Windows, Linux
    return 'http://127.0.0.1:8000';
  }

  static Uri chatUri() => Uri.parse('$baseUrl/chat/');
  static Uri recommendUri() => Uri.parse('$baseUrl/recommend/');
  static Uri modelStatusUri() => Uri.parse('$baseUrl/model/status');
}
