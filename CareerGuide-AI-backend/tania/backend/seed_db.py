
import asyncio
import json
import os
from app.core.database import async_session
from app.core.models import University

async def seed_data():
    # Chemin vers le fichier JSON
    json_path = os.path.join("app", "data", "universities.json")
    
    if not os.path.exists(json_path):
        print(f"Fichier {json_path} non trouvé.")
        return

    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    async with async_session() as session:
        for item in data:
            # On vérifie si l'université existe déjà
            from sqlalchemy import select
            result = await session.execute(select(University).where(University.name == item["name"]))
            if result.scalar_one_or_none():
                continue

            # Création de l'objet University avec des valeurs par défaut pour les champs manquants
            university = University(
                name=item["name"],
                city=item["city"],
                category="Université",  # Par défaut
                type="Public",           # Par défaut
                level="Post-Bac",        # Par défaut
                filiere_list=item.get("filieres", []),
                scholarships=[],
                description=f"Établissement situé à {item['city']}."
            )
            session.add(university)
        
        await session.commit()
        print("Données insérées avec succès !")

if __name__ == "__main__":
    asyncio.run(seed_data())
