from pydantic import BaseModel, ConfigDict
from typing import List, Optional

class UniversityBase(BaseModel):
    name: str
    city: str
    category: str
    type: str
    level: str
    image_url: Optional[str] = None
    description: Optional[str] = None
    filiere_list: List[str] = []
    fees: Optional[str] = None
    scholarships: List[str] = []
    contact_phone: Optional[str] = None
    contact_email: Optional[str] = None
    admission_date: Optional[str] = None

class UniversityCreate(UniversityBase):
    pass

class UniversityResponse(UniversityBase):
    id: int
    model_config = ConfigDict(from_attributes=True)
