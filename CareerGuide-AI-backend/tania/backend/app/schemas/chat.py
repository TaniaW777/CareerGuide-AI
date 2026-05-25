from pydantic import BaseModel
from typing import Optional, Dict, Any


class ChatRequest(BaseModel):
    message: str
    recommended_program: Optional[str] = None
    profile: Optional[Dict[str, Any]] = None