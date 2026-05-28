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
    final topPercentile = recommendations.first['percentile'];
    
    // Get schools info if available
    final topSchools = (recommendations.first['schools'] as List?)?.map((s) => s['name']).toList() ?? [];

    String analysis = _getOpening(level, stream);
    analysis += _getSubjectAndInterestAnalysis(subjects, interests);
    analysis += _getDetailedPathAnalysis(topProgram, topPercentile, level, topSchools);

    return analysis;
  }

  static String _getOpening(String level, String stream) {
    final openings = [
      "En analysant minutieusement ton profil d'élève en $level ${stream.isNotEmpty ? '(série $stream)' : ''}, ",
      "Suite à l'évaluation approfondie de tes aptitudes et compte tenu de ton niveau en $level, ",
      "Ton profil est très prometteur. En tant qu'élève de $level, ",
    ];
    return openings[_random.nextInt(openings.length)];
  }

  static String _getSubjectAndInterestAnalysis(List<String> subjects, List<String> interests) {
    String text = "";
    
    if (subjects.isNotEmpty) {
      text += "je remarque une excellente disposition pour des matières comme ${subjects.join(', ')}. Cela dénote des capacités solides d'analyse et un haut potentiel de réussite dans des environnements exigeants. ";
    } else {
      text += "ton profil montre une grande polyvalence académique. ";
    }

    if (interests.isNotEmpty) {
      text += "De plus, tes centres d'intérêt pour ${interests.join(' et ')} sont des atouts majeurs. Ils me permettent de cibler des filières où ta passion sera le moteur de ton excellence professionnelle. ";
    }

    return text;
  }

  static String _getDetailedPathAnalysis(String topProgram, String percentile, String level, List<dynamic> schools) {
    String schoolsText = "";
    if (schools.isNotEmpty) {
      schoolsText = "Tu pourrais envisager des établissements de référence tels que ${schools.take(2).join(' ou ')}. ";
    }

    if (level == '3ème') {
      return "\n\nC'est pourquoi la série ou filière '$topProgram' (Compatibilité: $percentile) ressort comme la recommandation idéale. Elle capitalise parfaitement sur tes forces pour te préparer au lycée. " +
             schoolsText + 
             "Les débouchés après ce parcours incluent des carrières techniques pointues ou de solides études supérieures, t'assurant un emploi stable et valorisant.";
    } else {
      return "\n\nAinsi, le domaine de '$topProgram' (Compatibilité: $percentile) est hautement recommandé. Ce parcours universitaire correspond exactement à tes compétences. " +
             schoolsText + 
             "Les débouchés de cette filière sont excellents et te mèneront vers des postes de responsabilité, d'innovation ou d'expertise dans ton secteur d'activité, très demandés sur le marché du travail actuel.";
    }
  }
}
