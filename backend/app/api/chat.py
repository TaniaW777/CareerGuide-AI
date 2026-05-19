from fastapi import APIRouter
from app.schemas.chat import ChatRequest
from app.services.chat_service import generate_reply

router = APIRouter()


@router.post("/")
def chat(req: ChatRequest):
    reply = generate_reply(
        req.message,
        req.recommended_program
    )

    return {
        "reply": reply
    }