import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:careerguide_ai/services/local_ia/local_ai_service.dart';

Future<void> main() async {
  // Initialise le système IA offline (DB, seed data)
  await LocalAIService.initialize();

  // Profil utilisateur d'exemple
  final profile = {
    'first_name': 'Alex',
    'class_level': '3ème',
    'stream': 'Scientifique',
    'favorite_subjects': ['Mathématiques', 'Physique'],
    'interests': ['Ingénierie', 'Recherche'],
  };

  // Conversation avec le conseiller IA
  final question = "Quel parcours devrais‑je suivre pour devenir ingénieur ?";
  final reply = await LocalAIService.generateChatReply(question, profile, onlineMode: false);
  debugPrint('AI reply: $reply');

  // Obtenir les recommandations et l'analyse
  final rec = await LocalAIService.getRecommendations(profile, onlineMode: false);
  debugPrint('Recommendations and analysis:');
  debugPrint(rec.toString());
}
