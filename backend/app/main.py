from fastapi import FastAPI
from app.api import recommendation, chat, model

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

app.include_router(
    model.router,
    prefix="/model",
    tags=["Model"]
)
@app.get("/")
def root():
    return {"message": "backend running"}