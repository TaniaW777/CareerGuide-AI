# CareerGuide AI Frontend – Project Overview & Test Guide

## What this repository contains
- A **Flutter** mobile/web app that offers offline‑first career guidance.
- An **offline AI stack** based on a local SQLite database and a simple rule‑based/LLM fallback (`LocalAIService`).
- A **backend** (FastAPI) running on `localhost:8001` that can be used for online mode.

## Key components
| Component | Purpose | Location |
|-----------|---------|----------|
| `lib/services/database/local_db.dart` | SQLite wrapper (sqflite + ffi) – stores users, universities, chat messages. | `lib/services/database/` |
| `lib/services/local_ia/local_ai_service.dart` | Offline AI orchestration: recommendation scoring, chat reply generation, DB seeding. | `lib/services/local_ia/` |
| `lib/services/local_ia/ollama_engine.dart` | Wrapper for a local Ollama LLM (offline). | `lib/services/local_ia/` |
| `lib/screens/dashboard_screen.dart` | Main UI – shows recommendations, quick actions, and premium banner. | `lib/screens/` |
| `test_ai.dart` *(new)* | Small Dart script that **initialises the AI system**, fetches **offline recommendations**, and prints a **sample chat reply**. | Project root (`CareerGuide_AI_frontend/`) |

## How to run the UI (Flutter)
1. **Install dependencies** (run once):
   ```powershell
   cd C:\Users\azili\OneDrive\Desktop\CareerGuide\CareerGuide_AI_frontend
   flutter pub get
   ```
2. **Run the app** – you can target Chrome (web) or Windows (desktop). For a quick test on Chrome:
   ```powershell
   flutter run -d chrome
   ```
   *Note*: When running on the web the app uses the regular `sqflite` implementation, so no `sqflite_common_ffi_web` is needed.
3. The dashboard will load the user profile from `SharedPreferences` and call:
   ```dart
   LocalAIService.getRecommendations(profile, onlineMode: false);
   ```
   which pulls data from the local SQLite DB and shows it in the UI.

## How to test the AI logic directly (CLI script)
The script `test_ai.dart` does everything without launching Flutter:
```powershell
# From the project root
dart run test_ai.dart
```
What it does:
1. **Seeds the local DB** (creates tables and inserts university data if empty).
2. **Creates a sample user profile** (first name, class level, favourite subjects, etc.).
3. **Calls** `LocalAIService.getRecommendations` in offline mode and prints the JSON result.
4. **Calls** `LocalAIService.generateChatReply` with a sample question and prints the reply.

### Expected output example
```
--- Recommendations ---
{"recommendations":[{"program":"Informatique","score":87,"percentile":95,"schools":[...]}],"analysis":"..."}
--- Chat Reply ---
"Salut Azili! …"
```
If you see errors about missing packages, make sure `flutter pub get` has been run and that the **project name** (`careerguide_ai`) matches the import path used in the script.

## Backend (optional – online mode)
A FastAPI server is located in `CareerGuide-AI-backend/tania/backend`. Start it with:
```powershell
uvicorn app.main:app --host 127.0.0.1 --port 8001
```
When `onlineMode: true` is passed to the AI service, it will contact this server for chat replies.

## Troubleshooting
- **Blank screen / white page** – often caused by the web build trying to use `sqflite_common_ffi`. The conditional import in `local_db.dart` now guards against this. Use Chrome (web) or Windows (desktop) after a clean rebuild (`flutter clean`).
- **Package not found** – ensure the import uses the correct package name (`careerguide_ai`). The `test_ai.dart` script lives in the project root, so the import resolves.
- **Locked build folder** – kill lingering Flutter/Dart processes (`taskkill /F /IM flutter.exe` etc.) or delete the `build` directory manually.

---
*This README was generated automatically by the Antigravity coding assistant to document the current state, testing approach, and how to run the project.*
