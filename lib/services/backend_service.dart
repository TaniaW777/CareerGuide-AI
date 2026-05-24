import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/backend_config.dart';

class BackendService {
  static Uri get _recommendUri => BackendConfig.recommendUri();
  static const String _cacheKey = 'backend_recommendations_cache';
  static const String _cacheAnalysisKey = 'backend_recommendations_analysis_cache';
  static const String _cacheTimestampKey = 'backend_recommendations_cache_time';

  static Future<Map<String, dynamic>> getRecommendations(Map<String, dynamic> profile) async {
    try {
      print("Frontend: Tentative d'envoi du profil au backend: ${jsonEncode(profile)}");
      final response = await http
          .post(
            _recommendUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(profile),
          )
          .timeout(const Duration(seconds: 12));

      print("Frontend: Réponse backend reçue avec code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = _normalizeRecommendations(data);
        final analysis = data['analysis']?.toString() ?? '';

        print("Frontend: ${items.length} recommandations normalisées.");
        await _saveCache(items, analysis);
        return {
          'recommendations': items,
          'analysis': analysis,
        };
      } else {
        print("Frontend: Erreur backend non-200: ${response.body}");
      }
    } catch (e) {
      print("Frontend: Erreur lors de la récupération des recommandations: $e");
    }

    print("Frontend: Passage au mode offline (Cache)");
    final cached = await getCachedRecommendations();
    return {
      'recommendations': cached?['recommendations'] ?? [],
      'analysis': cached?['analysis'] ?? '',
    };
  }

  static Future<Map<String, dynamic>?> getCachedRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final rawRecommendations = prefs.getString(_cacheKey);
    final rawAnalysis = prefs.getString(_cacheAnalysisKey);
    if (rawRecommendations == null || rawRecommendations.isEmpty) {
      return null;
    }

    final data = jsonDecode(rawRecommendations);
    if (data is List) {
      return {
        'recommendations': data.cast<Map<String, dynamic>>(),
        'analysis': rawAnalysis ?? '',
      };
    }
    return null;
  }

  static Future<void> _saveCache(List<Map<String, dynamic>> items, String analysis) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(items));
    await prefs.setString(_cacheAnalysisKey, analysis);
    await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static List<Map<String, dynamic>> _normalizeRecommendations(Map<String, dynamic> payload) {
    final raw = payload['recommendations'];
    if (raw is! List) {
      return [];
    }

    return raw.map<Map<String, dynamic>>((entry) {
      final item = entry as Map<String, dynamic>;
      return {
        'program': item['program'] ?? 'Programme inconnu',
        'score': item['score'] ?? 0,
        'schools': item['schools'] ?? [],
      };
    }).toList();
  }
}
