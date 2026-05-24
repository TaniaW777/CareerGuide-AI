import 'dart:convert';
import 'dart:math';
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
    String subStr = subjects.isNotEmpty ? subjects.join(" et ") : "tes matières";
    String intStr = interests.isNotEmpty ? interests.join(" ou ") : "tes passions";

    switch (intent) {
      case 'career':
        return "Le choix d'un métier est crucial. Puisque tu t'intéresses à $intStr, tu pourrais viser des secteurs en pleine croissance. Pense à ce que tu aimes faire au quotidien : est-ce que c'est résoudre des problèmes, aider les gens, ou créer de nouvelles choses ?";
      
      case 'orientation':
        if (level == '3ème') {
          return "Après la 3ème, le choix entre la Seconde générale (pour faire des longues études) ou technique/professionnelle (pour apprendre un métier plus vite) dépend de tes notes en $subStr. Si tu es fort en théorie, la générale est parfaite.";
        } else {
          return "En Terminale $stream, tes choix universitaires doivent être stratégiques. Les filières liées à $intStr sont une suite logique. Il faut regarder les universités qui proposent des parcours adaptés à la série $stream.";
        }
        
      case 'academic':
        return "Tes performances en $subStr sont de bons indicateurs. Ce sont ces matières qui vont dicter la série ou la filière où tu vas exceller. Ne néglige pas pour autant les autres disciplines qui t'apportent une culture générale forte.";
        
      case 'finance':
        return "Concernant le financement, sache qu'il existe des bourses de l'État (comme le CIOSPB ou le FONER) pour les étudiants excellents ou ceux ayant des difficultés financières. L'essentiel est de maintenir un dossier académique solide.";
        
      case 'greeting':
        return "Je suis ton Conseiller IA 100% hors-ligne. Je m'adapte à ton profil d'élève en $level pour te guider.";
        
      case 'gratitude':
        return "N'oublie pas que je reste disponible à tout moment, même sans connexion internet, pour t'accompagner.";
        
      default:
        return "En tant que conseiller, je prends en compte que tu es en $level. Parle-moi davantage de ce qui t'intéresse, comme $intStr, ou de tes matières fortes comme $subStr. Plus j'aurai de détails, mieux je pourrai t'orienter.";
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
      print("Erreur historique chat: \$e");
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
