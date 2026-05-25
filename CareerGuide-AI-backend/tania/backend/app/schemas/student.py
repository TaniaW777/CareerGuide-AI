from pydantic import BaseModel, ConfigDict
from typing import List, Optional

class UserBase(BaseModel):
    phone: str
    first_name: str
    last_name: str
    age: int

class UserCreate(UserBase):
    pass

class UserResponse(UserBase):
    id: int
    model_config = ConfigDict(from_attributes=True)

class ProfileBase(BaseModel):
    first_name: Optional[str] = None
    class_level: Optional[str] = None
    stream: Optional[str] = None
    city: Optional[str] = None
    interests: List[str] = []
    favorite_subjects: List[str] = []

class ProfileCreate(ProfileBase):
    user_id: int

class ProfileResponse(ProfileBase):
    id: int
    user_id: int
    model_config = ConfigDict(from_attributes=True)

# Alias pour la compatibilité avec les anciens services
StudentProfile = ProfileBase
