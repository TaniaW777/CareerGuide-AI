from fastapi import FastAPI
from app.api import recommendation, chat

app = FastAPI(title="CareerGuideAI")

app.include_router(
    recommendation.router,
    prefix="/recommend",
    tags=["Recommendation"]
)

app.include_router(
    chat.router,
    prefix="/chat",
    tags=["Chat"]
)

@app.get("/")
def root():
    return {"message": "backend running"}