def recommend(profile: dict):
    scores = {
        "Médecine": 0,
        "Pharmacie": 0,
        "Informatique": 0,
        "Agronomie": 0
    }

    subjects = profile["subjects"]
    interest = profile["interest"]

    if "SVT" in subjects:
        scores["Médecine"] += 40
        scores["Pharmacie"] += 30
        scores["Agronomie"] += 20

    if "PC" in subjects:
        scores["Médecine"] += 20
        scores["Pharmacie"] += 20

    if "Math" in subjects:
        scores["Informatique"] += 40

    if interest == "Santé":
        scores["Médecine"] += 30
        scores["Pharmacie"] += 20

    if interest == "Technologie":
        scores["Informatique"] += 30

    ranked = sorted(
        scores.items(),
        key=lambda x: x[1],
        reverse=True
    )

    return ranked[:3]