// ───────────────────────────────────────────────────
// Moteur d'Orientation Déterministe (Dart)
// Zéro hallucination - Matching basé sur règles
// ───────────────────────────────────────────────────

enum NiveauEtude { postBepc, postBac, inconnu }

enum SerieBac { A, C, D, E, F, G, inconnue }

enum CategorieInteret {
  sciencesExactes,
  sciencesVie,
  numerique,
  techniqueIndustriel,
  economieGestion,
  agriculture,
  sante,
  sciencesHumaines,
  artCulture,
  droitAdmin,
  nonDetecte,
}

class Filiere {
  final String nom;
  final String etablissement;
  final NiveauEtude niveau;
  final List<SerieBac> seriesCompatibles;
  final List<String> motsCles;

  Filiere({
    required this.nom,
    required this.etablissement,
    required this.niveau,
    this.seriesCompatibles = const [],
    this.motsCles = const [],
  });
}

class OrientationResponse {
  final NiveauEtude niveauDetecte;
  final SerieBac serieDetectee;
  final List<CategorieInteret> interetsDetectes;
  final List<Filiere> filieres;
  final String messagePersonnalise;
  final String questionRelance;
  final String confiance; // 'elevee', 'moyenne', 'faible'

  OrientationResponse({
    required this.niveauDetecte,
    required this.serieDetectee,
    required this.interetsDetectes,
    required this.filieres,
    required this.messagePersonnalise,
    required this.questionRelance,
    required this.confiance,
  });
}

class AnalyseInput {
  final String message;
  final String? conversationPrecedente;

  AnalyseInput({required this.message, this.conversationPrecedente});
}

// ───────────────────────────────────────────────────
// Données des filières (à compléter selon tes besoins)
// ───────────────────────────────────────────────────
final List<Filiere> FILIERES = [
  Filiere(
    nom: "Informatique",
    etablissement: "UJKZ",
    niveau: NiveauEtude.postBac,
    seriesCompatibles: [SerieBac.C, SerieBac.D, SerieBac.E],
    motsCles: ['informatique', 'programmer', 'coder', 'tech', 'web'],
  ),
  Filiere(
    nom: "Génie Civil",
    etablissement: "2iE",
    niveau: NiveauEtude.postBac,
    seriesCompatibles: [SerieBac.C, SerieBac.E],
    motsCles: ['génie civil', 'construction', 'bâtiment'],
  ),
  Filiere(
    nom: "Sciences Économiques",
    etablissement: "UNZ",
    niveau: NiveauEtude.postBac,
    seriesCompatibles: [SerieBac.A, SerieBac.G],
    motsCles: ['économie', 'commerce', 'gestion'],
  ),
  // Ajoute ici toutes tes autres filières...
];

class OrientationEngine {
  static NiveauEtude detecterNiveau(String texte) {
    final t = texte.toLowerCase();
    if (RegExp(r'bepc|3[eè]me|troisi[èe]me|brevet|coll[èe]ge').hasMatch(t) &&
        !RegExp(r'bac|terminale').hasMatch(t)) {
      return NiveauEtude.postBepc;
    }
    if (RegExp(r'bac|terminale|tle|bachelier|universit[ée]').hasMatch(t)) {
      return NiveauEtude.postBac;
    }
    return NiveauEtude.inconnu;
  }

  static SerieBac detecterSerie(String texte) {
    final t = texte.toLowerCase();

    final match = RegExp(r's[ée]rie\s*([a-g])').firstMatch(t);
    if (match != null) {
      final s = match.group(1)!.toUpperCase();
      if (['A', 'C', 'D', 'E', 'F', 'G'].contains(s)) {
        return SerieBac.values.firstWhere((e) => e.toString().split('.').last == s);
      }
    }

    if (RegExp(r'lettre|litt[ée]rature|philo|fran[cç]ais').hasMatch(t)) return SerieBac.A;
    if (RegExp(r'math[ée]matique|physique|math.{0,3}phys').hasMatch(t)) return SerieBac.C;
    if (RegExp(r'svt|biologie|science.{0,3}vie').hasMatch(t)) return SerieBac.D;
    if (RegExp(r'math.{0,3}tech|g[ée]nie').hasMatch(t)) return SerieBac.E;
    if (RegExp(r'industriel|m[ée]canique|électricit[ée]').hasMatch(t)) return SerieBac.F;
    if (RegExp(r'commerce|comptabilit[ée]|gestion').hasMatch(t)) return SerieBac.G;

    return SerieBac.inconnue;
  }

  static List<CategorieInteret> detecterInterets(String texte) {
    final t = texte.toLowerCase();
    final scores = <CategorieInteret, int>{};

    final grille = {
      CategorieInteret.sciencesExactes: ['maths', 'mathématiques', 'physique', 'chimie'],
      CategorieInteret.sciencesVie: ['svt', 'biologie', 'écologie'],
      CategorieInteret.numerique: ['informatique', 'coder', 'programmer', 'web'],
      CategorieInteret.techniqueIndustriel: ['mécanique', 'électricité', 'réparer'],
      CategorieInteret.economieGestion: ['commerce', 'économie', 'gestion'],
      CategorieInteret.agriculture: ['agriculture', 'cultiver', 'ferme'],
      CategorieInteret.sante: ['médecin', 'santé', 'infirmier'],
      CategorieInteret.sciencesHumaines: ['histoire', 'philosophie'],
      CategorieInteret.artCulture: ['art', 'musique', 'dessin'],
      CategorieInteret.droitAdmin: ['droit', 'justice', 'avocat'],
    };

    for (var entry in grille.entries) {
      for (var mot in entry.value) {
        if (t.contains(mot)) {
          scores[entry.key] = (scores[entry.key] ?? 0) + 10;
          break;
        }
      }
    }

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final result = sorted.map((e) => e.key).take(3).toList();

    return result.isNotEmpty ? result : [CategorieInteret.nonDetecte];
  }

  static List<Filiere> matcherFilieres(
    NiveauEtude niveau,
    SerieBac serie,
    List<CategorieInteret> interets,
    String texte,
  ) {
    final candidates = FILIERES.where((f) {
      if (niveau != NiveauEtude.inconnu && f.niveau != niveau) return false;
      if (niveau == NiveauEtude.postBac &&
          serie != SerieBac.inconnue &&
          !f.seriesCompatibles.contains(serie)) {
        return false;
      }
      return true;
    }).toList();

    // Scoring simple
    final scored = candidates.map((f) {
      int score = 0;
      final t = texte.toLowerCase();
      for (var mot in f.motsCles) {
        if (t.contains(mot)) score += 20;
      }
      return {'filiere': f, 'score': score};
    }).toList();

    scored.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    return scored
        .where((s) => (s['score'] as int) > 0)
        .take(3)
        .map((s) => s['filiere'] as Filiere)
        .toList();
  }

  static String genererMessagePersonnalise(
    NiveauEtude niveau,
    SerieBac serie,
    List<CategorieInteret> interets,
    List<Filiere> filieres,
  ) {
    if (filieres.isEmpty) {
      return "Je n'ai pas assez d'éléments pour te proposer des filières précises. Donne-moi plus de détails sur tes résultats et tes passions.";
    }

    final noms = filieres.map((f) => "• ${f.nom} à ${f.etablissement}").join("\n");
    final prefix = niveau == NiveauEtude.postBepc ? "après le BEPC" : "après le BAC";

    String msg = "Voici les filières les plus adaptées à ton profil $prefix :\n\n$noms";

    if (serie != SerieBac.inconnue && niveau == NiveauEtude.postBac) {
      msg += "\n\nAvec un BAC série ${serie.toString().split('.').last}, ces formations sont bien adaptées.";
    }

    return msg;
  }

  static String genererQuestionRelance(
    NiveauEtude niveau,
    SerieBac serie,
    List<Filiere> filieres,
  ) {
    if (niveau == NiveauEtude.inconnu) {
      return "Es-tu en 3ème (préparation BEPC) ou en Terminale (BAC) ?";
    }
    if (niveau == NiveauEtude.postBac && serie == SerieBac.inconnue) {
      return "Quelle série de BAC as-tu (A, C, D, E, F, G) ?";
    }
    if (filieres.isEmpty) {
      return "Quelles sont tes matières préférées ?";
    }

    final questions = [
      "Veux-tu plus de détails sur l'une de ces filières ?",
      "Préfères-tu une formation courte (BTS) ou longue (Licence) ?",
      "As-tu une ville préférée (Ouaga, Bobo, etc.) ?",
    ];

    return questions[DateTime.now().millisecond % questions.length];
  }

  // API principale
  static OrientationResponse analyserEtOrienter(AnalyseInput input) {
    final texteComplet = input.conversationPrecedente != null
        ? "${input.conversationPrecedente} ${input.message}"
        : input.message;

    final niveau = detecterNiveau(texteComplet);
    final serie = niveau == NiveauEtude.postBac ? detecterSerie(texteComplet) : SerieBac.inconnue;
    final interets = detecterInterets(texteComplet);
    final filieres = matcherFilieres(niveau, serie, interets, texteComplet);

    final message = genererMessagePersonnalise(niveau, serie, interets, filieres);
    final question = genererQuestionRelance(niveau, serie, filieres);

    String confiance = 'faible';
    if (filieres.length >= 2) confiance = 'elevee';
    else if (filieres.isNotEmpty) confiance = 'moyenne';

    return OrientationResponse(
      niveauDetecte: niveau,
      serieDetectee: serie,
      interetsDetectes: interets,
      filieres: filieres,
      messagePersonnalise: message,
      questionRelance: question,
      confiance: confiance,
    );
  }
}