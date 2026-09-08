import json
from pathlib import Path

# Chemin résolu à partir de ce fichier : le backend démarre correctement
# quel que soit le répertoire de lancement (racine du dépôt ou backend/).
DATA_PATH = Path(__file__).resolve().parents[1] / "data" / "universities.json"

with open(DATA_PATH, "r", encoding="utf-8") as f:
    DB = json.load(f)


def retrieve(program: str):
    matches = []

    for school in DB:
        if program in school["filieres"]:
            matches.append({
                "name": school["name"],
                "city": school["city"]
            })

    return matches