from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import httpx
import asyncio

app = FastAPI(title="CareerGuide Web Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

OLLAMA_URL = "http://127.0.0.1:11434/api/chat"
OLLAMA_MODEL = "gemma:2b"

class ProfileData(BaseModel):
    name: Optional[str] = None
    age: Optional[str] = None
    education: Optional[str] = None
    interests: Optional[List[str]] = []
    skills: Optional[str] = None
    goals: Optional[str] = None

class ChatRequest(BaseModel):
    message: str
    profile: Optional[ProfileData] = None
    session_id: Optional[str] = "default"

class ChatResponse(BaseModel):
    reply: str

@app.get("/")
async def root():
    return {"status": "ok", "service": "CareerGuide Web Backend"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    profile_context = ""
    if req.profile:
        p = req.profile
        parts = []
        if p.name: parts.append(f"Prénom: {p.name}")
        if p.education: parts.append(f"Niveau d'études: {p.education}")
        if p.interests: parts.append(f"Centres d'intérêt: {', '.join(p.interests)}")
        if p.skills: parts.append(f"Compétences: {p.skills}")
        if p.goals: parts.append(f"Objectif: {p.goals}")
        profile_context = " | ".join(parts)

    system_prompt = (
        "Tu es un conseiller d'orientation scolaire professionnel et bienveillant basé au Burkina Faso. "
        "Tu maîtrises parfaitement le système éducatif burkinabè. "
        "Voici les règles absolues pour le système éducatif du Burkina Faso:\n"
        "- Série C : BAC Scientifique axé Mathématiques et Physique-Chimie (ce n'est pas un jeu vidéo éducatif, c'est un diplôme du lycée pour scientifiques très poussé).\n"
        "- Série D : BAC Scientifique axé Sciences de la Vie et de la Terre (Biologie).\n"
        "- Série A : BAC Littéraire (Langues, Philosophie, Lettres).\n"
        "- Série E : Mathématiques et Technique.\n"
        "- Série F : BAC Technologique.\n"
        "- Série G : BAC en techniques quantitatives de gestion et secrétariat.\n"
        "- Collège = de la 6ème à la 3ème. Le diplôme est le BEPC. Après la 3ème on choisit la 2nde ou le CAP/BEP.\n"
        "- Lycée = de la 2nde à la Terminale. Le diplôme est le BAC.\n"
        "Ne mentionne que la réalité du système éducatif du Burkina Faso. "
        "Réponds en français, sois concis, clair, et apporte des conseils concrets. "
        f"\n\nProfil actuel de l'étudiant qui te parle : {profile_context or 'Non renseigné'}."
    )

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            resp = await client.post(OLLAMA_URL, json={
                "model": OLLAMA_MODEL,
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": req.message}
                ],
                "stream": False
            })
            if resp.status_code == 200:
                data = resp.json()
                reply = data.get("message", {}).get("content", "").strip()
                if reply:
                    return ChatResponse(reply=reply)
    except Exception as e:
        print(f"Ollama error: {e}")

    # Fallback built-in response if Ollama is unreachable
    fallback = generate_fallback(req.message, req.profile)
    return ChatResponse(reply=fallback)

def generate_fallback(message: str, profile: Optional[ProfileData]) -> str:
    lower = message.lower()
    name = profile.name if profile and profile.name else "toi"
    level = profile.education if profile and profile.education else "ton niveau"

    if any(w in lower for w in ["série c", "serie c"]):
        return "Au Burkina Faso, la Série C est une filière scientifique très exigeante axée sur les Mathématiques et les Sciences Physiques. Elle ouvre les portes aux études d'ingénierie, d'informatique, de mathématiques fondamentales ou de physique à l'université."

    if any(w in lower for w in ["série d", "serie d"]):
        return "La Série D est une filière scientifique orientée vers les Sciences de la Vie et de la Terre (Biologie, Médecine, Agronomie). C'est idéal si tu aimes les sciences naturelles."

    if any(w in lower for w in ["stress", "angoisse", "peur", "inquiet"]):
        return f"Je comprends que tu puisses te sentir stressé(e), {name}. L'orientation est un processus, pas une décision unique. Parlons de ce qui t'inquiète le plus et avançons ensemble, étape par étape."

    if any(w in lower for w in ["bonjour", "salut", "hello"]):
        return f"Bonjour {name} ! Je suis ton Conseiller IA CareerGuide. Je suis là pour t'aider à explorer ton avenir au Burkina Faso. Que souhaites-tu savoir ?"

    if any(w in lower for w in ["métier", "carrière", "travail", "profession"]):
        return f"En tant qu'élève en {level}, tu as beaucoup de possibilités. Je te recommande d'explorer d'abord tes centres d'intérêt — que ce soit la technologie, les arts, les sciences ou le social — et de choisir une filière qui te motive vraiment."

    return f"Bonne question ! En tant qu'élève en {level}, il existe de nombreuses voies possibles au Burkina. Dis-moi ce qui te passionne et ce que tu voudrais éviter — je te proposerai des pistes concrètes et adaptées."
