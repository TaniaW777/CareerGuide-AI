from fastapi import APIRouter
from app.schemas.chat import ChatRequest
from app.services.chat_service import generate_reply

router = APIRouter()


@router.post("/")
async def chat(req: ChatRequest):
    # On utilise le profil envoyé par le frontend pour une réponse personnalisée
    reply = await generate_reply(
        req.message,
        user_profile=req.profile
    )

    return {
        "reply": reply
    }