from pydantic import BaseModel


class ChatRequest(BaseModel):
    message: str
    recommended_program: str