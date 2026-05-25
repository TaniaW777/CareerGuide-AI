import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_db.dart';

class EnhancedChatService {
  static final Random _random = Random();

  static Future<String> generateSmartReply(
    String userMessage,
    Map<String, dynamic> profile,
  ) async {
    final msg = userMessage.toLowerCase();
    final name = profile['first_name'] ?? 'l\'ami';
    final level = profile['class_level'] ?? '3ème';
    final stream = profile['stream'] ?? '';
    final subjects = List<String>.from(profile['favorite_subjects'] ?? []);
    final interests = List<String>.from(profile['interests'] ?? []);
    
    // 1. Analyse de l'intention et de l'émotion
    final intent = _analyzeIntent(msg);
    final isQuestion = userMessage.contains('?');
    
    // 2. Génération dynamique de la réponse en combinant des blocs
    String response = "";
    
    // a. Amorce (Empathy / Connection)
    response += _getOpening(intent, name, level) + " ";
    
    // b. Cœur du message (Contexte)
    response += _getCoreMessage(intent, level, stream, subjects, interests, msg) + " ";
    
    // c. Conclusion / Question ouverte
    if (!isQuestion || intent == 'general') {
      response += _getClosingQuestion(intent, level);
    }
    
    // Sauvegarder dans l'historique
    await _saveToHistory(userMessage, response, profile);
    
    return response.trim();
  }

  static String _analyzeIntent(String msg) {
    if (msg.contains('bonjour') || msg.contains('salut') || msg.contains('coucou')) return 'greeting';
    if (msg.contains('merci') || msg.contains('compris')) return 'gratitude';
    if (msg.contains('aide') || msg.contains('perdu') || msg.contains('sais pas')) return 'confusion';
    if (msg.contains('métier') || msg.contains('devenir') || msg.contains('travail')) return 'career';
    if (msg.contains('lycée') || msg.contains('série') || msg.contains('filière')) return 'orientation';
    if (msg.contains('note') || msg.contains('matière') || msg.contains('maths')) return 'academic';
    if (msg.contains('bourse') || msg.contains('argent') || msg.contains('foner')) return 'finance';
    return 'general';
  }

  static String _getOpening(String intent, String name, String level) {
    final greetings = [
      "Salut $name !",
      "Bonjour $name,",
      "Coucou $name !",
      "Ravi de discuter avec toi $name."
    ];
    
    final empathy = [
      "Je comprends tout à fait ta situation.",
      "C'est une excellente question, surtout en $level.",
      "Je vois exactement ce que tu veux dire.",
      "C'est normal de se poser cette question à ton niveau."
    ];
    
    if (intent == 'greeting') return greetings[_random.nextInt(greetings.length)];
    if (intent == 'confusion') return "Pas de panique $name, je suis là pour t'aider à y voir plus clair. Prendre une décision en $level n'est pas toujours facile.";
    if (intent == 'gratitude') return "C'est un plaisir de t'aider $name !";
    
    return empathy[_random.nextInt(empathy.length)];
  }

  static String _getCoreMessage(String intent, String level, String stream, List<String> subjects, List<String> interests, String rawMsg) {
    String subStr = subjects.isNotEmpty ? subjects.join(" et ") : "tes matières favorites";
    String intStr = interests.isNotEmpty ? interests.join(" ou ") : "tes centres d'intérêt";

    switch (intent) {
      case 'career':
        return "Le choix d'un métier est une étape passionnante ! Puisque tu t'intéresses à $intStr, tu pourrais viser des secteurs porteurs comme le numérique, la santé ou l'agro-industrie au Burkina Faso. Pense à ce que tu aimes faire au quotidien : préfères-tu résoudre des problèmes complexes, aider les gens, ou créer de nouvelles choses avec tes mains ?";
      
      case 'orientation':
        if (level == '3ème') {
          return "Après la 3ème, tu as un carrefour important. Tu peux choisir la Seconde générale (Séries A, C ou D) pour des études longues, ou la filière technique (Séries E, F, G) pour apprendre un métier concret plus rapidement. Tes bons résultats en $subStr sont un excellent indicateur pour choisir ta série.";
        } else {
          return "En Terminale $stream, tes choix universitaires sont la priorité. Les filières liées à $intStr sont une suite logique. Au Burkina, des universités comme l'UJKZ ou l'UNB proposent des parcours d'excellence adaptés à la série $stream. As-tu déjà une idée de l'université qui te tente ?";
        }
        
      case 'academic':
        return "Tes performances en $subStr montrent ton potentiel. Ce sont ces forces qui vont te permettre de réussir dans les filières les plus sélectives. N'oublie pas que même les matières qui te semblent moins importantes contribuent à forger une culture générale solide, très appréciée par les employeurs.";
        
      case 'finance':
        return "C'est un point crucial. Au Burkina, sache qu'il existe des aides précieuses : le CIOSPB pour les bourses nationales et internationales, et le FONER pour les prêts d'études. L'essentiel est de garder une moyenne solide. Veux-tu que je t'explique comment constituer un dossier de bourse ?";
        
      case 'greeting':
        return "Je suis votre conseiller IA de CareerGuide. Même sans connexion internet, je reste à tes côtés pour analyser ton profil d'élève en $level et t'aider à tracer ton futur chemin professionnel.";
        
      case 'gratitude':
        return "C'est toujours un plaisir de t'éclairer ! Mon but est que tu puisses choisir ton avenir avec confiance et sérénité. Je suis disponible 24h/24, ici même sur ton téléphone.";
        
      default:
        return "C'est une réflexion intéressante pour un élève en $level. D'après ton profil, tes passions pour $intStr et tes compétences en $subStr sont tes meilleurs atouts. Pourrais-tu me dire quel type d'activité te rend le plus fier(e) à l'école ?";
    }
  }

  static String _getClosingQuestion(String intent, String level) {
    if (intent == 'gratitude') return "As-tu d'autres préoccupations ?";
    if (intent == 'greeting') return "Que souhaites-tu explorer aujourd'hui : tes choix d'études, les métiers, ou les bourses ?";
    
    final questions = [
      "Qu'en penses-tu ?",
      "Est-ce que cette direction te semble intéressante ?",
      "Y a-t-il un domaine particulier que tu aimerais qu'on approfondisse ?",
      "Veux-tu qu'on regarde des exemples concrets d'établissements ?",
      "As-tu une idée précise du secteur dans lequel tu te vois plus tard ?"
    ];
    return questions[_random.nextInt(questions.length)];
  }

  static Future<void> _saveToHistory(String message, String reply, Map<String, dynamic> profile) async {
    try {
      final db = await LocalDatabase.database;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 0;

      await db.insert('chat_messages', {
        'user_id': userId,
        'message': message,
        'reply': reply,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Erreur historique chat: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getChatHistory(int userId) async {
    try {
      final db = await LocalDatabase.database;
      return await db.query('chat_messages', where: 'user_id = ?', whereArgs: [userId], orderBy: 'timestamp ASC');
    } catch (e) {
      return [];
    }
  }
}
