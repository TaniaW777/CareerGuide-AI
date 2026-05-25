
class ScoringService {
  /// Advanced scoring system that takes into account student level, subjects, interests, and stream
  static List<Map<String, dynamic>> recommend(Map<String, dynamic> profile) {
    Map<String, int> scores = {};
    
    final level = profile['class_level'] ?? '3ème';
    final subjects = List<String>.from(profile['favorite_subjects'] ?? []);
    final interests = List<String>.from(profile['interests'] ?? []);
    final stream = profile['stream'] ?? '';

    // Initialize scores based on level
    if (level == '3ème') {
      scores = {
        "Lycée Scientifique": 0,
        "Lycée Technique": 0,
        "Lycée Général": 0,
        "Centre de Formation Professionnelle": 0
      };
      _scoreFor3eme(scores, subjects, interests, stream);
    } else if (level == 'Tle' || level == 'Terminale') {
      scores = {
        "Médecine & Santé": 0,
        "Génie Logiciel & IA": 0,
        "Économie & Gestion": 0,
        "Droit & Sciences Po": 0,
        "Agronomie & Environnement": 0,
        "Art & Communication": 0,
        "Génie Civil & Infrastructure": 0,
        "Énergie & Ressources": 0,
      };
      _scoreForTerminale(scores, stream, subjects, interests);
    } else {
      scores = {
        "Formation Générale": 0,
        "Formation Technique": 0,
        "Formation Professionnelle": 0,
      };
    }

    // Common scoring for all levels
    _scoreBySubjects(scores, subjects, level);
    _scoreByInterests(scores, interests, level);
    _applyPerformanceBonus(scores, profile);

    // Sort and return top recommendations (only those with positive scores)
    final sortedList = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final result = sortedList
        .where((e) => e.value > 0)
        .map((e) => {
          "program": e.key,
          "score": e.value,
          "percentile": "${((e.value ~/ 10).clamp(0, 100))}%"
        })
        .toList();
    
    // Return at least 1 recommendation (top even if score is 0) for edge cases
    if (result.isEmpty && sortedList.isNotEmpty) {
      final topEntry = sortedList.first;
      return [{
        "program": topEntry.key,
        "score": topEntry.value,
        "percentile": "${((topEntry.value ~/ 10).clamp(0, 100))}%"
      }];
    }
    
    return result;
  }

  /// Scoring logic specifically for 3ème students
  static void _scoreFor3eme(
    Map<String, int> scores,
    List<String> subjects,
    List<String> interests,
    String stream,
  ) {
    // Science subjects = Science stream
    int scienceCount = subjects.where((s) => 
      s.contains("Mathématiques") || 
      s.contains("Physique") || 
      s.contains("Chimie") ||
      s.contains("SVT")
    ).length;

    if (scienceCount >= 2) {
      scores["Lycée Scientifique"] = (scores["Lycée Scientifique"] ?? 0) + 50;
    }

    // Tech subjects = Technical stream
    if (subjects.contains("Informatique") || 
        subjects.contains("Technologie") ||
        subjects.contains("Électronique")) {
      scores["Lycée Technique"] = (scores["Lycée Technique"] ?? 0) + 45;
    }

    // Humanities + Languages = General stream
    if (subjects.contains("Français") || 
        subjects.contains("Anglais") ||
        subjects.contains("Histoire-Géographie")) {
      scores["Lycée Général"] = (scores["Lycée Général"] ?? 0) + 40;
    }
  }

  /// Scoring logic for Terminale students
  static void _scoreForTerminale(
    Map<String, int> scores,
    String stream,
    List<String> subjects,
    List<String> interests,
  ) {
    // Stream-based routing
    switch (stream.toUpperCase()) {
      case 'D':
        scores["Médecine & Santé"] = (scores["Médecine & Santé"] ?? 0) + 70;
        scores["Agronomie & Environnement"] = 
            (scores["Agronomie & Environnement"] ?? 0) + 50;
        scores["Génie Civil & Infrastructure"] = 
            (scores["Génie Civil & Infrastructure"] ?? 0) + 30;
        break;
      case 'C':
        scores["Génie Logiciel & IA"] = 
            (scores["Génie Logiciel & IA"] ?? 0) + 70;
        scores["Médecine & Santé"] = (scores["Médecine & Santé"] ?? 0) + 40;
        scores["Énergie & Ressources"] = 
            (scores["Énergie & Ressources"] ?? 0) + 30;
        break;
      case 'A':
        scores["Droit & Sciences Po"] = 
            (scores["Droit & Sciences Po"] ?? 0) + 70;
        scores["Art & Communication"] = 
            (scores["Art & Communication"] ?? 0) + 60;
        scores["Économie & Gestion"] = 
            (scores["Économie & Gestion"] ?? 0) + 40;
        break;
      case 'E':
      case 'F':
        scores["Génie Logiciel & IA"] = 
            (scores["Génie Logiciel & IA"] ?? 0) + 60;
        scores["Génie Civil & Infrastructure"] = 
            (scores["Génie Civil & Infrastructure"] ?? 0) + 60;
        scores["Économie & Gestion"] = 
            (scores["Économie & Gestion"] ?? 0) + 40;
        break;
    }
  }

  /// Score student based on subject strengths
  static void _scoreBySubjects(
    Map<String, int> scores,
    List<String> subjects,
    String level,
  ) {
    for (var subject in subjects) {
      final s = subject.toLowerCase();
      if (s.contains("mathématiques") || s.contains("maths")) {
        _increaseScores(scores, ["Génie Logiciel & IA", "Économie & Gestion"], 15);
      }
      if (s.contains("informatique") || s.contains("technologie")) {
        _increaseScores(scores, ["Génie Logiciel & IA"], 20);
      }
    }
  }

  /// Score student based on declared interests
  static void _scoreByInterests(
    Map<String, int> scores,
    List<String> interests,
    String level,
  ) {
    for (var interest in interests) {
      final i = interest.toLowerCase();
      if (i.contains("technologie") || i.contains("informatique")) {
        _increaseScores(scores, ["Génie Logiciel & IA"], 45);
      }
    }
  }

  /// Apply performance bonus
  static void _applyPerformanceBonus(
    Map<String, int> scores,
    Map<String, dynamic> profile,
  ) {
    final subjects = List<String>.from(profile['favorite_subjects'] ?? []);
    final interests = List<String>.from(profile['interests'] ?? []);

    if (subjects.length >= 3 && interests.length >= 2) {
      for (var entry in scores.entries) {
        if (entry.value > 50) {
          scores[entry.key] = entry.value + 10;
        }
      }
    }
  }

  /// Helper to increase scores
  static void _increaseScores(
    Map<String, int> scores,
    List<String> programs,
    int amount,
  ) {
    for (var program in programs) {
      if (scores.containsKey(program)) {
        scores[program] = (scores[program] ?? 0) + amount;
      }
    }
  }
}
