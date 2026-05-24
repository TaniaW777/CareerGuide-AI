import 'dart:math';

class RecommendationAnalyzer {
  static final Random _random = Random();

  /// Génère une analyse textuelle intelligente des recommandations
  static String generateAnalysis(
    Map<String, dynamic> profile,
    List<Map<String, dynamic>> recommendations,
  ) {
    if (recommendations.isEmpty) {
      return "Je n'ai pas pu générer de recommandations précises pour ton profil. Essaie de mettre à jour tes centres d'intérêt et tes matières préférées.";
    }

    final level = profile['class_level'] ?? '3ème';
    final stream = profile['stream'] ?? '';
    final subjects = List<String>.from(profile['favorite_subjects'] ?? []);
    final interests = List<String>.from(profile['interests'] ?? []);

    final topProgram = recommendations.first['program'];
    final topScore = recommendations.first['score'];
    final topPercentile = recommendations.first['percentile'];

    String analysis = _getOpening(level, stream);
    analysis += _getSubjectAndInterestAnalysis(subjects, interests);
    analysis += _getConclusion(topProgram, topPercentile, level);

    return analysis;
  }

  static String _getOpening(String level, String stream) {
    final openings = [
      "En analysant ton profil d'élève en $level ${stream.isNotEmpty ? '(série $stream)' : ''}, ",
      "Suite à l'évaluation de tes réponses et compte tenu de ton niveau en $level, ",
      "Ton profil est très intéressant. En tant qu'élève de $level, ",
    ];
    return openings[_random.nextInt(openings.length)];
  }

  static String _getSubjectAndInterestAnalysis(List<String> subjects, List<String> interests) {
    String text = "";
    
    if (subjects.isNotEmpty) {
      text += "je remarque une forte affinité pour des matières comme ${subjects.join(', ')}. Cela dénote des capacités d'analyse et d'apprentissage dans ces domaines. ";
    } else {
      text += "ton profil montre une grande polyvalence académique. ";
    }

    if (interests.isNotEmpty) {
      text += "De plus, tes centres d'intérêt pour ${interests.join(' et ')} me permettent de cibler des filières où ta passion sera un moteur de réussite. ";
    }

    return text;
  }

  static String _getConclusion(String topProgram, String percentile, String level) {
    if (level == '3ème') {
      return "\n\nC'est pourquoi la voie vers '$topProgram' (Compatibilité: $percentile) ressort comme ton meilleur choix. Elle capitalise parfaitement sur tes forces pour te préparer au lycée.";
    } else {
      return "\n\nAinsi, le domaine de '$topProgram' (Compatibilité: $percentile) est hautement recommandé pour toi. Ce parcours universitaire ou professionnel correspond exactement à tes compétences et aspirations futures.";
    }
  }
}
