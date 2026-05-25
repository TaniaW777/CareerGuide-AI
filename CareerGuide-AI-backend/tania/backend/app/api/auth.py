from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.core.database import get_db
from app.core.models import User, StudentProfile
from app.schemas.student import UserCreate, UserResponse, ProfileBase
from typing import Optional

router = APIRouter()

@router.post("/identify", response_model=UserResponse)
async def identify_user(user_data: UserCreate, db: AsyncSession = Depends(get_db)):
    # Vérifier si l'utilisateur existe déjà par son numéro de téléphone
    result = await db.execute(select(User).where(User.phone == user_data.phone))
    user = result.scalar_one_or_none()

    if user:
        # L'utilisateur existe, on met à jour ses infos si nécessaire et on le connecte
        user.first_name = user_data.first_name
        user.last_name = user_data.last_name
        user.age = user_data.age
    else:
        # Création d'un nouvel utilisateur
        user = User(
            phone=user_data.phone,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            age=user_data.age
        )
        db.add(user)
    
    await db.commit()
    await db.refresh(user)
    return user

@router.post("/profile/{user_id}")
async def update_profile(user_id: int, profile_data: ProfileBase, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(StudentProfile).where(StudentProfile.user_id == user_id))
    profile = result.scalar_one_or_none()

    if profile:
        profile.class_level = profile_data.class_level
        profile.stream = profile_data.stream
        profile.city = profile_data.city
        profile.interests = profile_data.interests
        profile.favorite_subjects = profile_data.favorite_subjects
    else:
        profile = StudentProfile(
            user_id=user_id,
            class_level=profile_data.class_level,
            stream=profile_data.stream,
            city=profile_data.city,
            interests=profile_data.interests,
            favorite_subjects=profile_data.favorite_subjects
        )
        db.add(profile)
    
    await db.commit()
    return {"message": "Profile updated successfully"}
