Map<String, dynamic> buildStudentProfile(String level, List<String> answers) {
  final subjects = <String>{};
  final interests = <String>{};
  var stream = '';

  bool containsAny(String source, List<String> tokens) {
    final text = source.toLowerCase();
    return tokens.any((token) => text.contains(token));
  }

  for (final answer in answers) {
    final text = answer.toLowerCase();
    if (text.isEmpty) continue;

    if (containsAny(text, ['math', 'logique', 'calcul', 'sciences', 'physique', 'ingenieur'])) {
      subjects.add('Mathématiques');
      interests.add('Technologie');
    }
    if (containsAny(text, ['écrire', 'lecture', 'lire', 'histoire', 'philosophie', 'langues', 'communication'])) {
      subjects.add('Français');
      interests.add('Art & Communication');
    }
    if (containsAny(text, ['dessin', 'peinture', 'créatif', 'création', 'bricolage', 'artistique'])) {
      interests.add('Art, Lettres & Communication');
    }
    if (containsAny(text, ['aider', 'médecin', 'infirmier', 'santé', 'social', 'psychologie', 'service'])) {
      interests.add('Médecine & Santé');
    }
    if (containsAny(text, ['ordinateur', 'informatique', 'programmation', 'code', 'robotique'])) {
      subjects.add('Informatique');
      interests.add('Technologie');
    }
    if (containsAny(text, ['recherche', 'laboratoire', 'science de la vie', 'biologie', 'chimie'])) {
      interests.add('Recherche');
    }
    if (containsAny(text, ['entreprise', 'entrepreneuriat', 'commerce', 'gestion', 'startup', 'business'])) {
      interests.add('Entrepreneuriat');
    }
    if (containsAny(text, ['droit', 'politique', 'journalisme', 'administration', 'criminologie'])) {
      interests.add('Droit & Sciences Politiques');
    }
    if (containsAny(text, ['culture', 'littérature', 'langue', 'philosophie', 'arts'])) {
      interests.add('Culture');
    }
    if (containsAny(text, ['agriculture', 'nature', 'environnement', 'écologie'])) {
      interests.add('Développement Rural');
    }
    if (level == '3ème' && stream.isEmpty) {
      if (containsAny(text, ['scientifique', 'science', 'maths', 'technologie'])) {
        stream = 'C';
      } else if (containsAny(text, ['littéraire', 'lettres', 'histoire', 'philosophie'])) {
        stream = 'A';
      } else if (containsAny(text, ['technique', 'professionnelle', 'mécanique', 'électrique'])) {
        stream = 'F';
      }
    }
  }

  if (subjects.isEmpty && interests.isEmpty) {
    interests.add(level == '3ème' ? 'Orientation générale' : 'Explorer plusieurs domaines');
  }

  return {
    'class_level': level,
    'stream': stream,
    'favorite_subjects': subjects.toList(),
    'interests': interests.toList(),
  };
}
