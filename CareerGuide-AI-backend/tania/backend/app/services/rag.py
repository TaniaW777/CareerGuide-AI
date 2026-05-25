import faiss
import numpy as np
from sentence_transformers import SentenceTransformer
from sqlalchemy import select
from sqlalchemy.exc import OperationalError
from app.core.database import async_session
from app.core.models import University
import json
import logging

logger = logging.getLogger(__name__)

# Modèle léger pour les embeddings - Lazy loaded
_model = None

# Index FAISS
index = None
university_map = {}

def get_model():
    global _model
    if _model is None:
        logger.info("⏳ Chargement du modèle d'embeddings (paraphrase-multilingual-MiniLM-L12-v2)...")
        _model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
        logger.info("✅ Modèle d'embeddings chargé.")
    return _model

async def build_index():
    global index, university_map
    model = get_model()
    async with async_session() as session:
        try:
            result = await session.execute(select(University))
            universities = result.scalars().all()
        except OperationalError as exc:
            # Database tables may not exist yet; do not crash the API.
            logger.warning("RAG build_index failed because database is not ready: %s", exc)
            return
        
        if not universities:
            return

        # Préparer les textes pour l'indexation
        texts = []
        for i, u in enumerate(universities):
            # On combine le nom, les filières et la ville pour la recherche
            filieres = ", ".join(u.filiere_list) if u.filiere_list else ""
            text = f"{u.name} à {u.city}. Filières: {filieres}. {u.description or ''}"
            texts.append(text)
            university_map[i] = u

        embeddings = model.encode(texts)
        dimension = embeddings.shape[1]
        
        index = faiss.IndexFlatL2(dimension)
        index.add(np.array(embeddings).astype('float32'))

async def retrieve(query: str, k: int = 3):
    global index, university_map
    model = get_model()
    
    if index is None:
        await build_index()
    
    if index is None:
        return []

    query_vector = model.encode([query])
    D, I = index.search(np.array(query_vector).astype('float32'), k * 2) # On cherche plus large pour filtrer ensuite
    
    results = []
    # Extraire le niveau du query si présent (ex: "pour niveau 3ème")
    target_level = None
    if "3ème" in query: target_level = "3ème"
    elif "Terminale" in query or "Tle" in query: target_level = "Post-Bac"

    for idx in I[0]:
        if idx in university_map:
            u = university_map[idx]
            
            # Filtrage strict par niveau si spécifié
            if target_level and u.level != target_level:
                continue

            results.append({
                "id": u.id,
                "name": u.name,
                "city": u.city,
                "category": u.category
            })
            
            if len(results) >= k:
                break
            
    return results
