from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, or_
from app.core.database import get_db
from app.core.models import University
from app.schemas.university import UniversityResponse
from typing import List, Optional

router = APIRouter()

@router.get("/", response_model=List[UniversityResponse])
async def search_institutions(
    q: Optional[str] = Query(None, description="Recherche par nom ou catégorie"),
    category: Optional[str] = Query(None, description="Filtre par catégorie (Lycée, Université, Institut)"),
    type: Optional[str] = Query(None, description="Filtre par type (Public, Privé)"),
    level: Optional[str] = Query(None, description="Filtre par niveau (3ème, Terminale, Post-Bac)"),
    city: Optional[str] = Query(None, description="Filtre par ville"),
    db: AsyncSession = Depends(get_db)
):
    query = select(University)

    if q:
        query = query.where(
            or_(
                University.name.ilike(f"%{q}%"),
                University.category.ilike(f"%{q}%")
            )
        )
    
    if category and category != "Tous":
        query = query.where(University.category == category)
    
    if type and type != "Tous":
        query = query.where(University.type == type)
        
    if level and level != "Tous":
        query = query.where(University.level == level)
        
    if city:
        query = query.where(University.city.ilike(f"%{city}%"))

    result = await db.execute(query)
    return result.scalars().all()

@router.get("/{university_id}", response_model=UniversityResponse)
async def get_institution_details(university_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(University).where(University.id == university_id))
    university = result.scalar_one_or_none()
    
    if not university:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Établissement non trouvé")
        
    return university
