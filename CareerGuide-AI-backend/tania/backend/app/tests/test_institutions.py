import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from app.main import app
from app.core.database import Base, get_db
from app.core.models import University

TEST_DATABASE_URL = "sqlite+aiosqlite:///:memory:"
engine = create_async_engine(TEST_DATABASE_URL, echo=False)
TestingSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

@pytest_asyncio.fixture(autouse=True)
async def setup_database():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    
    # Insérer des données de test
    async with TestingSessionLocal() as session:
        u1 = University(
            name="Lycée Polytechnique", city="Ouagadougou", category="Lycée",
            type="Public", level="3ème", filiere_list=["Technique"], scholarships=[]
        )
        u2 = University(
            name="Université JKZ", city="Ouagadougou", category="Université",
            type="Public", level="Post-Bac", filiere_list=["Médecine"], scholarships=[]
        )
        session.add_all([u1, u2])
        await session.commit()
        
    yield
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

async def override_get_db():
    async with TestingSessionLocal() as session:
        yield session

app.dependency_overrides[get_db] = override_get_db

@pytest.mark.asyncio
async def test_search_all():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        response = await ac.get("/institutions/")
    assert response.status_code == 200
    assert len(response.json()) == 2

@pytest.mark.asyncio
async def test_search_filter_category():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        response = await ac.get("/institutions/?category=Lycée")
    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]["name"] == "Lycée Polytechnique"

@pytest.mark.asyncio
async def test_search_query():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        response = await ac.get("/institutions/?q=JKZ")
    assert response.status_code == 200
    assert len(response.json()) == 1
    assert "JKZ" in response.json()[0]["name"]
