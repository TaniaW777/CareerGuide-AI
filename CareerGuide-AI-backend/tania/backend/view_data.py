
import asyncio
import json
from sqlalchemy import text
from app.core.database import engine

async def view_all_data():
    tables = ["users", "student_profiles", "universities", "chat_messages"]
    
    try:
        async with engine.connect() as conn:
            for table in tables:
                print(f"\n--- TABLE: {table.upper()} ---")
                result = await conn.execute(text(f"SELECT * FROM {table}"))
                
                # Récupérer les noms des colonnes
                columns = result.keys()
                rows = result.all()
                
                if not rows:
                    print("Table vide.")
                    continue
                
                for row in rows:
                    # Créer un dictionnaire pour un affichage propre
                    row_dict = dict(zip(columns, row))
                    # Formater le JSON pour une meilleure lisibilité
                    print(json.dumps(row_dict, indent=2, ensure_ascii=False))
                    print("-" * 20)
                    
    except Exception as e:
        print(f"Erreur lors de la lecture des données : {e}")
    finally:
        await engine.dispose()

if __name__ == "__main__":
    asyncio.run(view_all_data())
