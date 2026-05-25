import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:careerguide_ai/services/local_ia/local_ai_service.dart';


Future<void> main() async {
  // Initialize AI system (seed DB)
  await LocalAIService.initialize();

  // Sample user profile
  final profile = {
    'first_name': 'Alex',
    'last_name': 'Dupont',
    'class_level': '3ème',
    'stream': 'S',
    'favorite_subjects': ['Mathématiques', 'Physique'],
    'interests': ['Informatique', 'Robotics'],
    'city': 'Ouagadougou',
  };

  // Get recommendations
  final recs = await LocalAIService.getRecommendations(profile, onlineMode: false);
  debugPrint('--- Recommendations ---');
  debugPrint(jsonEncode(recs));

  // Generate a chat reply
  final reply = await LocalAIService.generateChatReply('Quel métier me conviendrait?', profile, onlineMode: false);
  debugPrint('--- Chat Reply ---');
  debugPrint(reply);
}
