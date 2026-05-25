from sqlalchemy import Column, Integer, String, ForeignKey, JSON
from sqlalchemy.orm import relationship
from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String, unique=True, index=True, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    age = Column(Integer, nullable=False)

    profile = relationship("StudentProfile", back_populates="user", uselist=False)
    chat_history = relationship("ChatMessage", back_populates="user")

class StudentProfile(Base):
    __tablename__ = "student_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    class_level = Column(String)  # 3ème, Tle, etc.
    stream = Column(String)       # A, D, C, etc.
    city = Column(String)
    interests = Column(JSON)      # Liste d'intérêts
    favorite_subjects = Column(JSON) # Liste de matières

    user = relationship("User", back_populates="profile")

class University(Base):
    __tablename__ = "universities"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    city = Column(String, nullable=False)
    category = Column(String, nullable=False)  # Lycée, Université, Institut
    type = Column(String, nullable=False)      # Public, Privé
    level = Column(String, nullable=False)     # 3ème, Terminale, Post-Bac
    image_url = Column(String)
    description = Column(String)
    filiere_list = Column(JSON)                # Liste des filières
    fees = Column(String)                      # Frais de scolarité
    scholarships = Column(JSON)                # Bourses disponibles
    contact_phone = Column(String)
    contact_email = Column(String)
    admission_date = Column(String)            # Date de rentrée

class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    message = Column(String, nullable=False)
    reply = Column(String, nullable=False)
    timestamp = Column(String) # On pourra utiliser DateTime plus tard

    user = relationship("User", back_populates="chat_history")
