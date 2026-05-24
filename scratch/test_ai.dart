import 'dart:convert';
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
  print('--- Recommendations ---');
  print(jsonEncode(recs));

  // Generate a chat reply
  final reply = await LocalAIService.generateChatReply('Quel métier me conviendrait?', profile, onlineMode: false);
  print('--- Chat Reply ---');
  print(reply);
}
