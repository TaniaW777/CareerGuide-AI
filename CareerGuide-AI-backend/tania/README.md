# CareerGuide AI — Backend (Python / FastAPI)

Service backend pour l'application CareerGuide AI. Fournit les API de recommandation, de recherche d'établissements et de chat/assistant.

Stack principal
- Python 3.10+ (recommandé 3.11)
- FastAPI
- Uvicorn (ASGI server)
- SQLAlchemy (async + asyncpg)
- PostgreSQL (par défaut, configurable via `DATABASE_URL`)

Fonctionnalités exposées (endpoints principaux)
- `GET /` — endpoint santé
- `POST /recommend/` — prend un profil d'élève et renvoie des recommandations (programme + score + écoles)
- `POST /chat/` — chat assistant (RAG/LLM) pour échanges conversationnels
- `GET /institutions/` — recherche d'établissements (filtres disponibles)
- `GET /institutions/{id}` — détails d'un établissement
- `POST /auth/identify` — création/identification d'utilisateur
- `POST /auth/profile/{user_id}` — mise à jour du profil étudiant

Prérequis
- Python 3.10+ installé
- PostgreSQL en local ou distant (ou changez `DATABASE_URL` pour pointer vers votre instance)

Installation locale
1. Créez et activez un environnement virtuel :

```bash
python -m venv .venv
# macOS / Linux
source .venv/bin/activate
# Windows (PowerShell)
.\.venv\Scripts\Activate.ps1
```

2. Installez les dépendances :

```bash
pip install -r backend/requirements.txt
```

Configuration
- Par défaut la configuration attend une variable d'environnement `DATABASE_URL`.
- Exemple local PostgreSQL :

```bash
export DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5432/careerguide
# Windows PowerShell
$env:DATABASE_URL = "postgresql+asyncpg://postgres:postgres@localhost:5432/careerguide"
```

Démarrage

```bash
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Tests

```bash
cd backend
pytest -q
```

Base de données
- Le projet utilise SQLAlchemy pour le modèle. Pour la production, il est recommandé d'ajouter Alembic pour les migrations.
- Pour un environnement de développement rapide, créez la base PostgreSQL (`careerguide`) et laissez SQLAlchemy gérer la session. Vous pouvez écrire un petit script d'initialisation si besoin.

Remarques techniques
- Code asynchrone avec `sqlalchemy.ext.asyncio` et `asyncpg`.
- Le module `app.services` contient la logique métier : `scoring`, `rag` (retrieval-augmented generation), gestion des modèles, et chat.
- Les données statiques (ex. `app/data/universities.json`) servent d'exemples et peuvent être utilisées pour peupler la base.

Sécurité & Production
- Ne pas exposer `DATABASE_URL` ou clés secrètes en clair. Utiliser des variables d'environnement et un gestionnaire de secrets en production.
- Ajouter maillage de logs, gestion des erreurs, monitoring et migrations (Alembic) avant mise en production.

Contribuer
- Ouvrez une issue décrivant le problème ou la fonctionnalité proposée.
- Créez une branche feature/bugfix et proposez une PR.

Contact
- Mainteneur: voir les métadonnées du dépôt.

Licence
- À définir.

