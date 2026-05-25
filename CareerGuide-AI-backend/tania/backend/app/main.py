from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import recommendation, chat, model, auth, institutions
from app.services.database_init import create_database, seed_universities

app = FastAPI(title="CareerGuideAI")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    auth.router,
    prefix="/auth",
    tags=["Authentication"]
)

app.include_router(
    institutions.router,
    prefix="/institutions",
    tags=["Institutions"]
)

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

@app.on_event("startup")
async def startup_event():
    try:
        await create_database()
        await seed_universities()
    except Exception as e:
        import logging
        logger = logging.getLogger(__name__)
        logger.error(f"❌ Erreur lors de l'initialisation au démarrage: {e}")


@app.get("/")
def root():
    return {"message": "backend running"}