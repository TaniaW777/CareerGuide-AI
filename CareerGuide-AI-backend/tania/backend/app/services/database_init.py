import json
import logging
import os

from sqlalchemy import select
from app.core.database import engine, async_session
from app.core.models import Base, University

logger = logging.getLogger(__name__)


async def create_database() -> None:
    """Create database tables if they do not exist."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    logger.info("✅ Base de données initialisée.")


async def seed_universities() -> None:
    """Seed universities from app/data/universities.json if the table is empty."""
    json_path = os.path.normpath(
        os.path.join(os.path.dirname(__file__), "..", "data", "universities.json")
    )

    if not os.path.exists(json_path):
        logger.warning("Fichier de données introuvable : %s", json_path)
        return

    with open(json_path, "r", encoding="utf-8") as f:
        seed_items = json.load(f)

    async with async_session() as session:
        for item in seed_items:
            result = await session.execute(select(University).where(University.name == item["name"]))
            if result.scalar_one_or_none():
                continue

            university = University(
                name=item["name"],
                city=item.get("city", ""),
                category=item.get("category", "Université"),
                type=item.get("type", "Public"),
                level=item.get("level", "Post-Bac"),
                filiere_list=item.get("filieres", []),
                scholarships=item.get("scholarships", []),
                description=item.get("description", f"Établissement situé à {item.get('city', 'une ville')}."),
            )
            session.add(university)

        await session.commit()
        logger.info("✅ Données des établissements insérées ou vérifiées.")
