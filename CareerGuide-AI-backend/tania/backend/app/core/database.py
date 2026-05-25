from sqlalchemy import make_url
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
import os

# Configuration de la base de données SQLite pour un fonctionnement offline total
# Utilise aiosqlite pour le support asynchrone
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite+aiosqlite:///./careerguide.db")

engine = create_async_engine(
    DATABASE_URL, 
    echo=True,
    connect_args={"check_same_thread": False} # Requis pour SQLite
)

async_session = async_sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

class Base(DeclarativeBase):
    pass

async def get_db():
    async with async_session() as session:
        yield session
