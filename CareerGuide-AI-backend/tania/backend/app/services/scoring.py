def recommend(profile: dict):
    class_level = profile.get("class_level")
    normalized_level = str(class_level or "").strip().lower()
    is_3eme = normalized_level in ["3ème", "3eme", "troisième", "troisieme", "3e", "3ème"]
    is_terminale = normalized_level in ["tle", "terminale", "terminal", "term"]

    # Dictionnaire de base des filières par niveau
    if is_3eme:
        scores = {
            "Lycée Scientifique": 10,
            "Lycée Technique": 10,
            "Lycée Général": 10,
            "Formation Professionnelle": 5
        }
    elif is_terminale:
        scores = {
            "Médecine & Santé": 10,
            "Génie Logiciel & IA": 10,
            "Économie & Gestion": 10,
            "Droit & Sciences Po": 10,
            "Agronomie": 10,
            "Art & Communication": 10
        }
    else:
        # Si le niveau est inconnu, on propose une logique neutre de débutant
        scores = {
            "Lycée Scientifique": 8,
            "Lycée Technique": 8,
            "Lycée Général": 8,
            "Formation Professionnelle": 6,
            "Médecine & Santé": 8,
            "Génie Logiciel & IA": 8,
            "Économie & Gestion": 8,
            "Droit & Sciences Po": 8,
            "Agronomie": 8,
            "Art & Communication": 8
        }

    subjects = profile.get("favorite_subjects", [])
    interests = profile.get("interests", [])
    stream = profile.get("stream", "")

    # Logique pour Terminale
    if normalized_level in ["tle", "terminale"]:
        # Influence de la série
        if stream == "D":
            scores["Médecine & Santé"] += 40
            scores["Agronomie"] += 30
        elif stream == "C":
            scores["Génie Logiciel & IA"] += 40
            scores["Médecine & Santé"] += 15
        elif stream == "A":
            scores["Droit & Sciences Po"] += 40
            scores["Art & Communication"] += 30
        elif stream in ["E", "F"]:
            scores["Génie Logiciel & IA"] += 40

        # Influence des matières
        for s in subjects:
            if s == "Mathématiques":
                scores["Génie Logiciel & IA"] += 20
                scores["Économie & Gestion"] += 20
            if s == "SVT":
                scores["Médecine & Santé"] += 20
                scores["Agronomie"] += 20
            if s in ["Philosophie", "Français"]:
                scores["Droit & Sciences Po"] += 15
                scores["Art & Communication"] += 15

    # Logique pour 3ème ou niveau inconnu
    else:
        for s in subjects:
            if s in ["Mathématiques", "Physique-Chimie"]:
                scores["Lycée Scientifique"] = scores.get("Lycée Scientifique", 0) + 30
                scores["Lycée Technique"] = scores.get("Lycée Technique", 0) + 15
            if s == "SVT":
                scores["Lycée Scientifique"] = scores.get("Lycée Scientifique", 0) + 15
            if s == "Informatique":
                scores["Lycée Technique"] = scores.get("Lycée Technique", 0) + 25
            
    # Influence des intérêts (commun)
    for interest in interests:
        i_low = interest.lower()
        if "santé" in i_low or "médecine" in i_low:
            if "Médecine & Santé" in scores: scores["Médecine & Santé"] += 35
        if "technologie" in i_low or "numérique" in i_low or "informatique" in i_low:
            if "Génie Logiciel & IA" in scores: scores["Génie Logiciel & IA"] += 35
            if "Lycée Technique" in scores: scores["Lycée Technique"] += 35
            if "Lycée Scientifique" in scores: scores["Lycée Scientifique"] += 15
        if "droit" in i_low or "politique" in i_low:
            if "Droit & Sciences Po" in scores: scores["Droit & Sciences Po"] += 35
        if "économie" in i_low or "gestion" in i_low or "commerce" in i_low:
            if "Économie & Gestion" in scores: scores["Économie & Gestion"] += 35

    ranked = sorted(
        scores.items(),
        key=lambda x: x[1],
        reverse=True
    )

    # Retourner les filières avec un score significatif
    return [r for r in ranked if r[1] > 15][:3]
