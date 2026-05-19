import json
from pathlib import Path

DATA_PATH = Path("app/data/career_advice.json")

with open(DATA_PATH, "r", encoding="utf-8") as f:
    ADVICE_DB = json.load(f)


def generate_reply(message: str, program: str):
    msg = message.lower()

    if "n'aime pas" in msg or "pas" in msg:
        return (
            f"Je comprends que {program} ne vous convient pas. "
            "Pouvez-vous préciser ce que vous recherchez ? "
            "Des études plus courtes ? un autre domaine ?"
        )

    if "courte" in msg or "court" in msg:
        options = ", ".join(
            ADVICE_DB["etudes_courtes"]
        )

        return (
            "Si vous préférez des études courtes, "
            f"je recommande : {options}."
        )

    if "technologie" in msg:
        options = ", ".join(
            ADVICE_DB["technologie"]
        )

        return (
            f"Dans le domaine technologie : {options}"
        )

    if "santé" in msg:
        options = ", ".join(
            ADVICE_DB["sante"]
        )

        return (
            f"Dans le domaine santé : {options}"
        )

    return (
        "Merci pour votre précision. "
        "Je vais ajuster ma recommandation."
    )