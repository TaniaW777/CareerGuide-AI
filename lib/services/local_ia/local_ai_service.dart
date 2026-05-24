import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/backend_config.dart';
import '../backend_service.dart';
import '../database/local_db.dart';
import 'scoring_service.dart';
import 'offline_ai_engine.dart';
import 'recommendation_analyzer.dart';

class LocalAIService {
  /// Get personalized recommendations based on student profile (Hybrid: Backend first if online)
  static Future<Map<String, dynamic>> getRecommendations(Map<String, dynamic> profile, {bool onlineMode = false}) async {
    if (onlineMode) {
      try {
        print("🌐 IA Hybride: Tentative de recommandations via le serveur...");
        final remoteResult = await BackendService.getRecommendations(profile);
        if (remoteResult['recommendations'] is List && (remoteResult['recommendations'] as List).isNotEmpty) {
          return {
            'recommendations': remoteResult['recommendations'],
            'analysis': remoteResult['analysis'] ?? '',
          };
        }
      } catch (e) {
        print("📡 Erreur serveur, bascule en mode Local RAG: $e");
      }
    }

    final results = ScoringService.recommend(profile);
    final db = await LocalDatabase.database;
    
    List<Map<String, dynamic>> enriched = [];
    final userLevel = profile['class_level'] ?? '3ème';
    // All local university data is Post-Bac, so use that as the lookup level
    // even for 3ème students to provide meaningful school suggestions.
    final targetLevel = 'Post-Bac';

    for (var res in results) {
      final program = res['program'];
      
      var schools = await db.query(
        'universities',
        where: 'level = ? AND (name LIKE ? OR filiere_list LIKE ?)',
        whereArgs: [targetLevel, '%$program%', '%$program%'],
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
        print("🌐 IA: Mode ONLINE actif - Contact du serveur local/distant...");
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
          print("📡 Réponse backend vide, bascule en mode LOCAL AI");
        } else {
          print("📡 Backend non disponible (code ${response.statusCode}), bascule en local.");
        }
      } catch (e) {
        print("📡 Connexion backend échouée, bascule en mode LOCAL AI: $e");
      }
    }

    print("🤖 LocalAI: Génération de réponse intelligente offline...");
    try {
      final reply = await OfflineAIEngine.generateChatReply(message, profile);
      return reply;
    } catch (e) {
      print("⚠️ Erreur lors de la génération: $e");
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
    print("🚀 Initialisation du système IA offline...");
    try {
      // Ensure database is ready
      await LocalDatabase.database;
      print("✅ Base de données locale initialisée");
      
      // Seed with university data if needed
      await LocalDatabase.seedDatabase();
      print("✅ Données pédagogiques chargées");
      
      print("🎉 Système IA 100% OFFLINE prêt!");
    } catch (e) {
      print("⚠️ Erreur lors de l'initialisation: $e");
    }
  }
}
