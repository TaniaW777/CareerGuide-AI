import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from app.main import app
from app.core.database import Base, get_db
import os

# Base de données de test SQLite en mémoire (pour simplifier les tests unitaires)
TEST_DATABASE_URL = "sqlite+aiosqlite:///:memory:"

engine = create_async_engine(TEST_DATABASE_URL, echo=False)
TestingSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

@pytest_asyncio.fixture(autouse=True)
async def setup_database():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

async def override_get_db():
    async with TestingSessionLocal() as session:
        yield session

app.dependency_overrides[get_db] = override_get_db

@pytest.mark.asyncio
async def test_identify_new_user():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        response = await ac.post("/auth/identify", json={
            "phone": "12345678",
            "first_name": "Jean",
            "last_name": "Dupont",
            "age": 18
        })
    assert response.status_code == 200
    assert response.json()["phone"] == "12345678"
    assert response.json()["first_name"] == "Jean"

@pytest.mark.asyncio
async def test_identify_existing_user():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # Premier appel pour créer
        await ac.post("/auth/identify", json={
            "phone": "87654321",
            "first_name": "Alice",
            "last_name": "Zongo",
            "age": 20
        })
        # Deuxième appel avec le même numéro
        response = await ac.post("/auth/identify", json={
            "phone": "87654321",
            "first_name": "Alice",
            "last_name": "Zongo Updated",
            "age": 21
        })
    assert response.status_code == 200
    assert response.json()["first_name"] == "Alice"
    assert response.json()["age"] == 21

@pytest.mark.asyncio
async def test_update_profile():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        # Créer l'utilisateur d'abord
        user_resp = await ac.post("/auth/identify", json={
            "phone": "55555555",
            "first_name": "Marc",
            "last_name": "Kaboré",
            "age": 17
        })
        user_id = user_resp.json()["id"]

        # Mettre à jour le profil
        response = await ac.post(f"/auth/profile/{user_id}", json={
            "class_level": "Tle",
            "stream": "D",
            "city": "Ouagadougou",
            "interests": ["Santé", "Science"],
            "favorite_subjects": ["SVT", "Math"]
        })
    assert response.status_code == 200
    assert response.json()["message"] == "Profile updated successfully"
