Map<String, dynamic> buildStudentProfile(String level, List<String> answers) {
  final subjects = <String>{};
  final interests = <String>{};
  var stream = '';

  if (answers.isNotEmpty) {
    // Q1: Activité préférée
    final q1 = int.tryParse(answers[0]) ?? 0;
    switch (q1) {
      case 0: // Maths/Logique
        subjects.add('Mathématiques');
        interests.add('Technologie');
        break;
      case 1: // Lecture/Ecriture
        subjects.add('Français');
        interests.add('Art & Communication');
        break;
      case 2: // Dessin/Bricolage
        interests.add('Art, Lettres & Communication');
        break;
      case 3: // Aider les autres
        interests.add('Médecine & Santé');
        break;
    }

    // Q2: Mode de travail
    if (answers.length > 1) {
      final q2 = int.tryParse(answers[1]) ?? 0;
      if (q2 == 3) subjects.add('Informatique'); // Travail pratique
    }

    // Q3: Motivation
    if (answers.length > 2) {
      final q3 = int.tryParse(answers[2]) ?? 0;
      switch (q3) {
        case 0: interests.add('Science et Technologie'); break;
        case 1: interests.add('Culture'); break;
        case 2: interests.add('Ingénierie'); break;
        case 3: interests.add('Économie & Gestion'); break;
      }
    }

    // Q4: Métier
    if (answers.length > 3) {
      final q4 = int.tryParse(answers[3]) ?? 0;
      switch (q4) {
        case 0: interests.add('Informatique & Numérique'); break;
        case 1: interests.add('Médecine & Santé'); break;
        case 2: interests.add('Droit & Sciences Politiques'); break;
        case 3: interests.add('Commerce et Gestion'); break;
      }
    }

    // Q5: Choix post-BEPC (3ème) ou Objectif (Tle)
    if (answers.length > 4) {
      final q5 = int.tryParse(answers[4]) ?? 0;
      if (level == '3ème') {
        switch (q5) {
          case 0: stream = 'C'; break;
          case 1: stream = 'A'; break;
          case 2: stream = 'F'; break;
        }
      } else {
        switch (q5) {
          case 1: interests.add('Entrepreneuriat'); break;
          case 2: interests.add('Recherche'); break;
        }
      }
    }
  }

  return {
    'class_level': level,
    'stream': stream,
    'favorite_subjects': subjects.toList(),
    'interests': interests.toList(),
  };
}
