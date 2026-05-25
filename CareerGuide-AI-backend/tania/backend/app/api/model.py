import asyncio
import json
import re
from fastapi import APIRouter, BackgroundTasks
from app.schemas.student import StudentProfile
from app.services.model_manager import (
    model_exists,
    download_model,
    get_progress
)
from app.services import gemma_engine, gemini_engine

router = APIRouter()

@router.get("/generate-questions")
async def generate_questions(level: str = "3ème"):
    """Génère des questions d'orientation personnalisées via l'IA."""
    prompt = (
        f"<start_of_turn>user\n"
        f"Tu es un conseiller d'orientation. "
        f"Génère 3 questions courtes pour un élève de niveau {level} afin de découvrir ses intérêts. "
        f"Réponds UNIQUEMENT avec un tableau JSON de chaînes de caractères.\n"
        f"Exemple: [\"Question 1\", \"Question 2\", \"Question 3\"]\n"
        f"<end_of_turn>\n"
        f"<start_of_turn>model\n"
    )
    
    if gemma_engine.is_ready():
        res = await asyncio.to_thread(gemma_engine.generate, prompt)
        if res:
            match = re.search(r'\[.*\]', res, re.DOTALL)
            if match:
                try:
                    return json.loads(match.group())
                except:
                    pass

    if gemini_engine.is_available():
        res = await asyncio.to_thread(gemini_engine.generate, prompt)
        if res:
            match = re.search(r'\[.*\]', res, re.DOTALL)
            if match:
                try:
                    return json.loads(match.group())
                except:
                    pass
    
    # Fallback si l'IA échoue
    if "3" in level:
        return [
            "Quelles sont tes trois matières préférées au collège ?",
            "Préfères-tu travailler avec tes mains ou avec ton esprit ?",
            "Quel métier te faisait rêver quand tu étais petit ?"
        ]
    return [
        "Dans quel domaine te vois-tu travailler plus tard ?",
        "Quelles compétences aimerais-tu développer à l'université ?",
        "Quels sont les sujets qui te passionnent en dehors des cours ?"
    ]


@router.post("/generate-personalized-questions")
async def generate_personalized_questions(profile: StudentProfile):
    """Génère des questions d'orientation personnalisées basées sur le profil de l'élève."""
    name = profile.first_name or "élève"
    level = profile.class_level or "3ème"
    stream = profile.stream or ""
    interests = ", ".join(profile.interests) if profile.interests else "non précisés"
    subjects = ", ".join(profile.favorite_subjects) if profile.favorite_subjects else "non précisées"
    
    prompt = (
        f"<start_of_turn>user\n"
        f"Tu es un conseiller d'orientation expert. "
        f"Génère 5 questions courtes et pertinentes pour un élève avec ce profil:\n"
        f"- Nom: {name}\n"
        f"- Niveau: {level}{f' (série {stream})' if stream else ''}\n"
        f"- Intérêts: {interests}\n"
        f"- Matières fortes: {subjects}\n\n"
        f"Les questions doivent l'aider à explorer son profil de manière plus approfondie. "
        f"Réponds UNIQUEMENT avec un tableau JSON de chaînes de caractères.\n"
        f"Exemple: [\"Question 1\", \"Question 2\", \"Question 3\", \"Question 4\", \"Question 5\"]\n"
        f"<end_of_turn>\n"
        f"<start_of_turn>model\n"
    )
    
    if gemma_engine.is_ready():
        res = await asyncio.to_thread(gemma_engine.generate, prompt)
        if res:
            match = re.search(r'\[.*\]', res, re.DOTALL)
            if match:
                try:
                    return {"questions": json.loads(match.group()), "source": "gemma"}
                except:
                    pass

    if gemini_engine.is_available():
        res = await asyncio.to_thread(gemini_engine.generate, prompt)
        if res:
            match = re.search(r'\[.*\]', res, re.DOTALL)
            if match:
                try:
                    return {"questions": json.loads(match.group()), "source": "gemini"}
                except:
                    pass
    
    # Fallback rule-based questions
    fallback_questions = [
        f"Quels domaines professionnels te fascinent particulièrement, {name} ?",
        "Y a-t-il un domaine où tu te sentirais complètement épanoui(e) dans ta carrière ?",
        f"En tant qu'élève de {level}, vois-tu plutôt ton avenir dans des études longues ou courtes ?",
        "Qu'est-ce qui te motive le plus dans un projet ou une activité ?",
        "Si tu pouvais changer une chose dans le système éducatif, ce serait quoi ?"
    ]
    
    return {"questions": fallback_questions, "source": "rule-based"}

@router.get("/status")
def status():
    return {
        "downloaded": model_exists(),
        "gemini_available": gemini_engine.is_available(),
        "gemma_ready": gemma_engine.is_ready(),
        "engine": "gemma" if gemma_engine.is_ready() else "gemini" if gemini_engine.is_available() else "rule-based"
    }


@router.post("/download")
def download(
    background_tasks: BackgroundTasks
):
    if model_exists():
        return {
            "message": "Model already downloaded",
            "progress": 100
        }

    background_tasks.add_task(
        download_model
    )

    return {
        "message": "Download started",
        "progress": 0
    }


@router.get("/progress")
def progress():
    return {
        "progress": get_progress()
    }