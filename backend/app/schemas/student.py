from pydantic import BaseModel
from typing import List


class StudentProfile(BaseModel):
    level: str
    series: str
    subjects: List[str]
    interest: str