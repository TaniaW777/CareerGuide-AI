import json
from pathlib import Path

DATA_PATH = Path("app/data/universities.json")

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