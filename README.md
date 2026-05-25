# CareerGuide AI - Orientation 3.0

CareerGuide AI est une application hybride d'orientation scolaire et professionnelle, conçue pour aider les élèves du collège et du secondaire à trouver des filières adaptées, en particulier au Burkina Faso.

## Vue d'ensemble

Le projet combine trois composants principaux :

- `CareerGuide_AI_frontend` : application Flutter mobile/desktop.
- `CareerGuide-AI-backend` : API Python FastAPI avec un moteur IA hybride.
- `Web_app` : interface web React/Vite.

L'objectif principal est de proposer un parcours d'orientation qui fonctionne en mode offline-first avec un modèle local (`Gemma`) et en fallback online via Gemini.

## Structure du projet

### `CareerGuide_AI_frontend`

- Application Flutter.
- Gère le profil élève, le questionnaire dynamique, le chat IA et l'affichage des recommandations.
- Se connecte au backend via `lib/core/config/backend_config.dart`.
- Utilise des endpoints backend pour :
  - `POST /chat/`
  - `POST /recommend/`
  - `POST /recommend/analysis/enhanced`
  - `GET /model/status`

### `CareerGuide-AI-backend`

- API FastAPI dans `tania/backend`.
- Inclut un moteur IA hybride :
  - `Gemma` local via Mediapipe pour l'inférence offline.
  - `Gemini` en ligne comme fallback.
- Endpoints principaux :
  - `GET /model/status`
  - `GET /generate-questions`
  - `POST /generate-personalized-questions`
  - `POST /chat/`
  - `POST /recommend/`
  - `POST /recommend/analysis/enhanced`

### `Web_app`

- Application React + Vite.
- Permet de discuter avec l'IA et de voir des recommandations.
- Utilise `VITE_BACKEND_URL` pour se connecter au backend.
- Pages principales :
  - `Chat.tsx`
  - `Recommendations.tsx`

## Fonctionnement interne

### Backend IA hybride

1. `Gemma` local est utilisé en priorité (offline-first).
2. Si `Gemma` n'est pas prêt, le backend bascule sur `Gemini` en ligne si une clé est configurée.
3. Si aucune IA n'est disponible, le backend applique un fallback rule-based.

### RAG et personnalisation

- Le backend enrichit les réponses avec des données pertinentes via un module RAG (`app/services/rag.py`).
- Les profils élèves sont utilisés pour personnaliser les prompts : niveau, série, intérêts, matières fortes.

### Mobile Flutter

- Le frontend Flutter charge dynamiquement les questionnaires depuis le backend.
- Les réponses sont stockées localement et envoyées au backend pour obtenir des recommandations.
- Le chat utilisateur passe par le backend, qui génère une réponse IA adaptée.

### Web React

- Le web appelle le même backend que le mobile.
- Il est capable d'utiliser le chat IA et la fonction de recommandation.
- L'URL backend est configurable via `VITE_BACKEND_URL`.

## Variables d'environnement

### Backend

- `GEMMA_MODEL_PATH` : chemin vers le fichier modèle Gemma local.
- `GOOGLE_API_KEY` ou `GEMINI_API_KEY` ou `Gemini_API_Key` : clé Gemini en ligne.
- `GEMINI_MODEL` : modèle Gemini à utiliser (par défaut `gemini-1.5-flash`).

### Web

- `VITE_BACKEND_URL` : URL du backend (par exemple `http://localhost:8000`).

### Mobile

- `BackendConfig` détermine l'URL du backend selon la plateforme :
  - Web : `http://127.0.0.1:8000`
  - Android : `http://10.0.2.2:8000`
  - iOS/macOS/Windows/Linux : `http://127.0.0.1:8000`

## Comment lancer le projet

### Backend

```bash
cd CareerGuide-AI-backend/tania/backend
python -m venv .venv
# Windows PowerShell
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Si vous souhaitez forcer un chemin de modèle local :

```bash
$env:GEMMA_MODEL_PATH = "C:\Users\azili\OneDrive\Desktop\CareerGuide\CareerGuide-AI-backend\tania\backend\models\gemma3-1b-it-int4.task"
$env:GEMINI_API_KEY = "votre_cle"
```

### Application mobile Flutter

```bash
cd CareerGuide_AI_frontend
flutter pub get
flutter run
```

### Application web

```bash
cd Web_app
npm install
npm run dev
```

Si vous utilisez une URL backend différente :

```bash
npm run dev -- --host 0.0.0.0
# ou définir VITE_BACKEND_URL dans un .env
```

## Déploiement GitHub

Ce projet est prêt à être poussé sur une branche `Careerguide`.

- Remote 1 : `https://github.com/TaniaW777/CareerGuide-AI.git`
- Remote 2 : `https://github.com/Aziliz-KABORE/CareerGuide-AI.git`

## Notes importantes

- Le backend est conçu pour favoriser l'usage local de Gemma sur mobile.
- La web app et le mobile partagent le même backend via des endpoints REST.
- Si le modèle local n'est pas disponible, Gemini en ligne est utilisé en fallback.
