"""
Chat service – Generates personalized replies for the student chat.

Strategy (in order):
1. Use the Gemma LLM (via gemma_engine) with RAG context if the model is
   loaded. This gives high-quality, conversational responses.
2. Fall back to the existing rule-based logic if Gemma is unavailable.
"""

import asyncio
import logging

from app.services.rag import retrieve
from app.services import gemma_engine, gemini_engine
from sqlalchemy import select
from app.core.database import async_session
from app.core.models import User, StudentProfile

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

async def get_user_profile(user_id: int):
    async with async_session() as session:
        result = await session.execute(
            select(User).where(User.id == user_id)
        )
        user = result.scalar_one_or_none()
        if not user: return None
        
        profile_res = await session.execute(
            select(StudentProfile).where(StudentProfile.user_id == user_id)
        )
        profile = profile_res.scalar_one_or_none()
        
        return {
            "first_name": user.first_name,
            "class_level": profile.class_level if profile else "3ème",
            "stream": profile.stream if profile else "",
            "interests": profile.interests if profile else [],
            "favorite_subjects": profile.favorite_subjects if profile else []
        }


def _build_gemma_prompt(message: str, profile: dict, context_text: str) -> str:
    """Build a chat prompt for Gemma with system instructions + RAG context."""
    name = profile.get("first_name", "étudiant")
    level = profile.get("class_level", "3ème")
    stream = profile.get("stream", "")
    interests = ", ".join(profile.get("interests", [])) or "non précisés"
    subjects = ", ".join(profile.get("favorite_subjects", [])) or "non précisées"

    system = (
        "Tu es un conseiller d'orientation scolaire expert au Burkina Faso. "
        "Tu es bienveillant, clair et concis. "
        "Tu donnes des conseils pratiques et personnalisés. "
        "Tu poses toujours une question ouverte à la fin de ta réponse pour faire avancer la conversation. "
        "Réponds UNIQUEMENT en français."
    )

    user_context = (
        f"Profil de l'élève : {name}, niveau {level}"
        f"{f', série {stream}' if stream else ''}, "
        f"matières favorites : {subjects}, "
        f"centres d'intérêt : {interests}."
    )

    rag_section = ""
    if context_text:
        rag_section = f"\n\nInformations pertinentes trouvées dans la base de données :\n{context_text}"

    prompt = (
        f"<start_of_turn>user\n"
        f"[Système] {system}\n\n"
        f"[Contexte élève] {user_context}"
        f"{rag_section}\n\n"
        f"[Message de l'élève] {message}\n"
        f"<end_of_turn>\n"
        f"<start_of_turn>model\n"
    )
    return prompt


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

async def generate_reply(message: str, user_id: int = None, user_profile: dict = None):
    # Si pas de profil fourni, on essaie de le récupérer via user_id
    if not user_profile and user_id:
        user_profile = await get_user_profile(user_id)

    if not user_profile:
        user_profile = {}

    msg = message.lower()
    user_name = user_profile.get("first_name", "étudiant")
    level = user_profile.get("class_level", "3ème")
    normalized_level = str(level or "").strip().lower()
    serie = user_profile.get("stream", "")
    interests = user_profile.get("interests", [])
    subjects = user_profile.get("favorite_subjects", [])

    # 1. Recherche d'informations pertinentes (RAG)
    context_docs = await retrieve(f"{message} {level}", k=2)
    context_text = ""
    if context_docs:
        context_text = ", ".join([d['name'] for d in context_docs])

    # -----------------------------------------------------------------------
    # 2. Try Gemma Local first (offline-first)
    # -----------------------------------------------------------------------
    if gemma_engine.is_ready():
        logger.info("🤖 Génération via Gemma LLM (offline-first)")
        prompt = _build_gemma_prompt(message, user_profile, context_text)
        gemma_reply = await asyncio.to_thread(gemma_engine.generate, prompt)
        if gemma_reply:
            return gemma_reply

    # -----------------------------------------------------------------------
    # 3. Try Gemini Online fallback
    # -----------------------------------------------------------------------
    if gemini_engine.is_available():
        logger.info("🌐 Génération via Gemini Online")
        prompt = _build_gemma_prompt(message, user_profile, context_text)
        gemini_reply = await asyncio.to_thread(gemini_engine.generate, prompt)
        if gemini_reply:
            return gemini_reply

    # -----------------------------------------------------------------------
    # 4. Fallback: rule-based logic (toujours fonctionnel)
    # -----------------------------------------------------------------------
    logger.info("📝 Fallback rule-based (Gemini/Gemma non disponible)")

    rag_suffix = ""
    if context_text:
        rag_suffix = f"\nEn regardant les établissements au Burkina, j'ai trouvé : {context_text}"

    # Salutations
    if any(keyword in msg for keyword in ["bonjour", "salut", "hey", "coucou"]):
        return f"Bonjour {user_name} ! Ravi de te voir. En tant qu'élève de {level} {serie}, je suis là pour t'aider à tracer ton chemin. Que souhaites-tu explorer aujourd'hui ?"

    # Demande de conseil d'orientation
    if any(keyword in msg for keyword in ["conseille", "suggère", "quoi faire", "choisir", "orientation", "aider"]):
        if normalized_level in ["tle", "terminale"]:
            interests_str = ", ".join(interests) if interests else "les études supérieures"
            return f"C'est un moment crucial, {user_name}. Avec ton profil en Terminale {serie}, {rag_suffix or 'il y a de nombreuses opportunités'}. D'après tes intérêts pour {interests_str}, penses-tu plus à l'université ou à une formation technique ?"
        else:
            subjects_str = ", ".join(subjects) if subjects else "apprendre"
            fallback_msg = "C'est le moment de bâtir tes bases"
            return f"Après la 3ème, tu as le choix entre les séries générales (A, C, D) ou techniques. {rag_suffix or fallback_msg}. Comme tu aimes {subjects_str}, je te suggère de regarder les séries qui mettent en avant tes matières fortes. Veux-tu qu'on les analyse ?"

    # Métiers et Futur
    if any(keyword in msg for keyword in ["métier", "devenir", "travail", "profession", "futur"]):
        return f"Pour devenir ce que tu souhaites après ton niveau {level}, {rag_suffix}. C'est un excellent projet. Quelles sont les compétences que tu préfères utiliser au quotidien ?"

    # Bourses
    if any(keyword in msg for keyword in ["bourse", "aide", "financement", "argent", "payer"]):
        return f"Le financement est important. Au Burkina, il existe des aides comme le FONER ou le CIOSPB. Pour ton niveau {level}, la moyenne est souvent déterminante. Veux-tu que je t'explique les critères ?"

    # Merci / Fin
    if any(keyword in msg for keyword in ["merci", "super", "cool", "merci beaucoup"]):
        return f"Avec plaisir, {user_name} ! N'hésite pas si tu as d'autres questions sur ton parcours de {level} {serie}. Je suis là pour ça !"

    # Fallback intelligent
    return f"C'est un point intéressant, {user_name}. En tant qu'élève de {level}, il est normal de se poser des questions sur son avenir. Pourrais-tu me préciser ce qui t'attire le plus dans ce domaine ?"
