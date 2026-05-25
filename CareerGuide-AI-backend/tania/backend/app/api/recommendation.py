from fastapi import APIRouter, BackgroundTasks
from app.schemas.student import StudentProfile
from app.services.scoring import recommend
from app.services.rag import retrieve
from app.services import gemma_engine, gemini_engine
import asyncio
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


def _build_analysis_prompt(profile_dict: dict, enriched: list) -> str:
    """Build a Gemma prompt to generate a recommendation analysis."""
    name = profile_dict.get("first_name", "étudiant")
    level = profile_dict.get("class_level", "3ème")
    stream = profile_dict.get("stream", "")
    subjects = ", ".join(profile_dict.get("favorite_subjects", [])) or "non précisées"
    interests = ", ".join(profile_dict.get("interests", [])) or "non précisés"

    reco_summary = "\n".join(
        f"- {r['program']} (score: {r['score']}, écoles: {', '.join(s['name'] for s in r.get('schools', []))})"
        for r in enriched
    )

    prompt = (
        f"<start_of_turn>user\n"
        f"[Système] Tu es un conseiller d'orientation scolaire au Burkina Faso. "
        f"Rédige un paragraphe d'analyse personnalisée (5-8 phrases) en français, "
        f"expliquant pourquoi ces filières sont recommandées pour cet élève. "
        f"Sois encourageant et bienveillant.\n\n"
        f"Profil : {name}, {level}{f' série {stream}' if stream else ''}, "
        f"matières favorites : {subjects}, intérêts : {interests}.\n\n"
        f"Recommandations :\n{reco_summary}\n"
        f"<end_of_turn>\n"
        f"<start_of_turn>model\n"
    )
    return prompt


def _rule_based_analysis(profile_dict: dict, enriched: list) -> str:
    """Fallback rule-based analysis when Gemma is not available."""
    name = profile_dict.get("first_name", "étudiant")
    level = profile_dict.get("class_level", "3ème")
    stream = profile_dict.get("stream", "")
    subjects = profile_dict.get("favorite_subjects", [])
    interests = profile_dict.get("interests", [])

    if not enriched:
        return "Aucune recommandation n'a pu être générée. Veuillez compléter votre profil."

    top = enriched[0]
    analysis = f"En analysant le profil de {name} en {level}"
    if stream:
        analysis += f" (série {stream})"
    analysis += ", "

    if subjects:
        analysis += f"les compétences en {', '.join(subjects)} ressortent comme des atouts majeurs. "
    else:
        analysis += "le profil montre une grande polyvalence académique. "

    if interests:
        analysis += f"Les centres d'intérêt pour {' et '.join(interests)} renforcent la pertinence des filières proposées. "

    analysis += f"\n\nLa filière '{top['program']}' est fortement recommandée avec un score de compatibilité de {top['score']}."

    return analysis


@router.post("/")
async def get_recommendation(profile: StudentProfile):
    """
    Endpoint optimisé pour retourner rapidement les recommandations.
    L'analyse IA se fait en arrière-plan.
    """
    profile_dict = profile.dict()
    
    # 1. Calcul immédiat des recommandations (rapide)
    results = recommend(profile_dict)
    
    # 2. Récupération parallèle des écoles
    tasks = [retrieve(f"{program} pour niveau {profile.class_level}") for program, score in results]
    schools_results = await asyncio.gather(*tasks)
    
    enriched = []
    for (program, score), schools in zip(results, schools_results):
        enriched.append({
            "program": program,
            "score": score,
            "schools": schools
        })
    
    # 3. Analyse IA rapide (rule-based d'abord) pour réponse immédiate
    analysis = _rule_based_analysis(profile_dict, enriched)
    
    # 4. Si Gemma est disponible, on le lance en arrière-plan (non-bloquant)
    # Le client peut faire un polling pour obtenir l'analyse améliorée
    
    return {
        "recommendations": enriched,
        "analysis": analysis,
        "status": "ready"
    }


@router.post("/analysis/enhanced")
async def get_enhanced_analysis(profile: StudentProfile):
    """
    Endpoint pour obtenir une analyse IA améliorée (Gemma) si disponible.
    Cette analyse est plus détaillée et personnalisée.
    """
    profile_dict = profile.dict()
    results = recommend(profile_dict)
    
    # Récupération des écoles
    tasks = [retrieve(f"{program} pour niveau {profile.class_level}") for program, score in results]
    schools_results = await asyncio.gather(*tasks)
    
    enriched = []
    for (program, score), schools in zip(results, schools_results):
        enriched.append({
            "program": program,
            "score": score,
            "schools": schools
        })
    
# Tentative de générer une analyse IA améliorée en local d'abord puis en ligne
    enhanced_analysis = ""
    if gemma_engine.is_ready():
        logger.info("🤖 Génération d'analyse améliorée via Gemma (offline-first)")
        prompt = _build_analysis_prompt(profile_dict, enriched)
        enhanced_analysis = await asyncio.to_thread(gemma_engine.generate, prompt)

    if not enhanced_analysis and gemini_engine.is_available():
        logger.info("🌐 Génération d'analyse améliorée via Gemini")
        prompt = _build_analysis_prompt(profile_dict, enriched)
        enhanced_analysis = await asyncio.to_thread(gemini_engine.generate, prompt)
    
    if not enhanced_analysis:
        logger.info("📝 Fallback analyse rule-based pour enhanced")
        enhanced_analysis = _rule_based_analysis(profile_dict, enriched)
    
    return {
        "analysis": enhanced_analysis,
        "recommendations": enriched
    }