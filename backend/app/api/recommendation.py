from fastapi import APIRouter
from app.schemas.student import StudentProfile
from app.services.scoring import recommend
from app.services.rag import retrieve

router = APIRouter()


@router.post("/")
def get_recommendation(profile: StudentProfile):
    results = recommend(profile.dict())

    enriched = []

    for program, score in results:
        schools = retrieve(program)

        enriched.append({
            "program": program,
            "score": score,
            "schools": schools
        })

    return {
        "recommendations": enriched
    }