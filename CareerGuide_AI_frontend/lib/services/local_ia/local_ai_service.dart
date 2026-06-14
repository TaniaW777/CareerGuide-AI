import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/config/backend_config.dart';
import 'gemma_engine.dart';
import '../backend_service.dart';
import '../database/local_db.dart';
import 'scoring_service.dart';
import 'offline_ai_engine.dart';
import 'recommendation_analyzer.dart';
import 'ollama_engine.dart';

class LocalAIService {
  /// Get personalized recommendations based on student profile (Hybrid: Backend first if online)
  static Future<Map<String, dynamic>> getRecommendations(Map<String, dynamic> profile, {bool onlineMode = false}) async {
    if (onlineMode) {
      try {
        debugPrint("🌐 IA Hybride: Tentative de recommandations via le serveur...");
        final remoteResult = await BackendService.getRecommendations(profile);
        if (remoteResult['recommendations'] is List && (remoteResult['recommendations'] as List).isNotEmpty) {
          return {
            'recommendations': remoteResult['recommendations'],
            'analysis': remoteResult['analysis'] ?? '',
          };
        }
      } catch (e) {
        debugPrint("📡 Erreur serveur, bascule en mode Local RAG: $e");
      }
    }

    final results = ScoringService.recommend(profile);
    final db = await LocalDatabase.database;
    
    List<Map<String, dynamic>> enriched = [];
    // All local university data is Post-Bac, so use that as the lookup level
    // even for 3ème students to provide meaningful school suggestions.
    final targetLevel = 'Post-Bac';

    for (var res in results) {
      final program = res['program'];
      final queryTerm = program.toString().toLowerCase();
      
      var schools = await db.query(
        'universities',
        where: 'level = ? AND (lower(name) LIKE ? OR lower(filiere_list) LIKE ?)',
        whereArgs: [targetLevel, '%$queryTerm%', '%$queryTerm%'],
        limit: 3,
      );

      if (schools.isEmpty) {
        schools = await db.query(
          'universities',
          where: 'level = ?',
          whereArgs: [targetLevel],
          limit: 3,
        );
      }

      enriched.add({
        "program": program,
        "score": res['score'],
        "percentile": res['percentile'],
        "schools": schools.map((s) => {
          "id": s['id'],
          "name": s['name'],
          "city": s['city'],
          "category": s['category'],
          "type": s['type'],
          "description": s['description']
        }).toList()
      });
    }

    final analysisText = RecommendationAnalyzer.generateAnalysis(profile, enriched);

    return {
      "recommendations": enriched,
      "analysis": analysisText
    };
  }

  /// Generate AI chat reply with dynamic switching between Online (Backend) and Offline (Local)
  static Future<String> generateChatReply(String message, Map<String, dynamic> profile, {bool onlineMode = false}) async {
    if (onlineMode) {
      try {
        debugPrint("🌐 IA: Mode ONLINE actif - Contact du serveur local/distant...");
        final response = await http.post(
          BackendConfig.chatUri(),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'message': message,
            'profile': profile,
          }),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final reply = data['reply']?.toString();
          if (reply != null && reply.trim().isNotEmpty) {
            return reply.trim();
          }
          debugPrint("📡 Réponse backend vide, bascule en mode LOCAL AI");
        } else {
          debugPrint("📡 Backend non disponible (code ${response.statusCode}), bascule en local.");
        }
      } catch (e) {
        debugPrint("📡 Connexion backend échouée, bascule en mode LOCAL AI: $e");
      }
    }

    debugPrint("🤖 LocalAI: Génération de réponse intelligente offline...");
    try {
      // Try Gemma model first
      final gemmaReply = await GemmaEngine.generate(message, profile);
      if (gemmaReply != null && gemmaReply.trim().isNotEmpty) {
        return gemmaReply;
      }
      debugPrint("⚙️ GemmaEngine unavailable or empty, falling back to Ollama...");
      // Ollama fallback (if still present)
      final ollamaReply = await OllamaEngine.generate(message, profile);
      if (ollamaReply != null && ollamaReply.trim().isNotEmpty) {
        return ollamaReply;
      }
      debugPrint("🦙 Ollama unavailable, falling back on rule‑based engine.");
      final reply = await OfflineAIEngine.generateChatReply(message, profile);
      return reply;
    } catch (e) {
      debugPrint("⚠️ Erreur lors de la génération: $e");
      return _getEmergencyFallback(profile);
    }
  }

  /// Emergency fallback response if something fails
  static String _getEmergencyFallback(Map<String, dynamic> profile) {
    final name = profile['first_name'] ?? 'ami';
    final level = profile['class_level'] ?? '3ème';
    
    if (level == '3ème') {
      return "Salut $name! 👋 Je suis ton conseiller d'orientation. Je t'aide à préparer ton futur en 3ème. "
             "Dis-moi ce qui t'intéresse (sciences, techniques, langues?) et je te guiderai!";
    } else {
      return "Bienvenue $name! 🎓 Tu es en Terminale - période clé pour ton orientation! "
             "Parle-moi de tes ambitions et je t'aiderai à trouver la meilleure filière.";
    }
  }

  /// Initialize the local AI system (seed database, prepare data)
  static Future<void> initialize() async {
    debugPrint("🚀 Initialisation du système IA offline...");
    try {
      // Ensure database is ready
      await LocalDatabase.database;
      debugPrint("✅ Base de données locale initialisée");
      
      // Seed with university data if needed
      await LocalDatabase.seedDatabase();
      debugPrint('✅ Données pédagogiques chargées');

      // Initialise the Gemma offline model
      await GemmaEngine.initialize();
      debugPrint('✅ Gemma model ready');      
      debugPrint("🎉 Système IA 100% OFFLINE prêt!");
    } catch (e) {
      debugPrint("⚠️ Erreur lors de l'initialisation: $e");
    }
  }
}
