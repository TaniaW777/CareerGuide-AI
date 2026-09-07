# CareerGuide AI

Application mobile d'orientation scolaire pour le Burkina Faso : questionnaire
d'intérêts, recommandations de filières et conseiller IA fonctionnant **sur
l'appareil** (Gemma 3 via `flutter_gemma`).

## Démarrage rapide

### Application mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

Au premier lancement, l'application télécharge le modèle IA local
(Gemma 3 1B int4, ~570 Mo) depuis GitHub Releases : **connexion Internet
requise à cette étape**. Ensuite, le conseiller IA fonctionne hors connexion.

### Backend (FastAPI, optionnel)

Le backend n'est pas nécessaire pour utiliser l'application : en son absence,
des recommandations locales de secours sont affichées.

```bash
python -m venv venv
venv/Scripts/activate        # Windows (source venv/bin/activate sous Linux/macOS)
python -m pip install -r backend/requirements.txt
python -m uvicorn app.main:app --app-dir backend --reload --host 0.0.0.0 --port 8000
```

Vérification : http://127.0.0.1:8000/docs (démarre correctement depuis la
racine du dépôt comme depuis `backend/`).

### Connecter l'application au backend

L'URL de l'API est fournie à la compilation (`--dart-define`), aucune IP
n'est codée en dur dans le code :

```bash
# Émulateur Android — valeur par défaut : http://10.0.2.2:8000
flutter run

# Appareil physique sur le réseau local du développeur
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000

# Production
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
```

## Architecture

- **Application mobile (`mobile/`, Flutter)**
  - **Conseiller IA local** : modèle Gemma 3 1B (int4) téléchargé une fois
    puis exécuté sur l'appareil via `flutter_gemma` ; le chat fonctionne sans
    connexion après installation. Un moteur déterministe de repli
    (`OrientationEngine`) répond si le modèle échoue.
  - **Questionnaire local** : réponses stockées sur l'appareil
    (SharedPreferences).
  - **Recommandations** : le backend est interrogé s'il est joignable
    (timeout 3 s) ; sinon, des recommandations de repli intégrées à
    l'application sont affichées, avec une bannière l'indiquant. Le résultat
    est conservé tel quel : **aucune synchronisation ultérieure** n'existe.
  - **Données de référence** (établissements, bourses, guides) : intégrées
    dans l'application. Les illustrations proviennent d'Unsplash et
    nécessitent Internet.
  - **Stockage local** : SharedPreferences (profil, questionnaire, dernière
    recommandation). L'historique des conversations n'est pas conservé après
    fermeture.

- **Backend (`backend/`, FastAPI)**
  - `POST /recommend/` : classement de filières par règles pondérées
    (Python pur) et association d'établissements via un fichier JSON local.
  - `POST /chat/` : réponses par détection de mots-clés (aucun modèle d'IA
    côté serveur).
  - Aucune base de données, aucune authentification, aucun CORS configuré.

## Statut hors ligne

> CareerGuide AI is partially offline-capable. After the initial download of
> the local Gemma model, the questionnaire, the on-device AI advisor, and
> local fallback recommendations can operate without a continuous Internet
> connection. The initial model download, server-backed recommendations, and
> remote images require connectivity. Automatic synchronization is not
> implemented yet.

En pratique :

- **Fonctionne hors connexion** (après installation du modèle) :
  questionnaire, conseiller IA local, recommandations de secours.
- **Nécessite Internet** : téléchargement initial du modèle (~570 Mo),
  recommandations serveur, images distantes (Unsplash).
- **Non implémenté** : synchronisation automatique au retour du réseau,
  rejeu des questionnaires vers le serveur.

## Limitations connues

- Le premier lancement exige Internet (téléchargement du modèle) ;
- les recommandations de repli sont génériques, moins personnalisées que
  celles du serveur ;
- l'historique des conversations avec le conseiller IA est perdu à la
  fermeture de l'application ;
- les fiches établissements, bourses et notifications sont des données de
  démonstration ; les formulaires de candidature sont des simulations :
  **aucune candidature réelle n'est transmise** ;
- le support Web (déploiement GitHub Pages) du plugin IA local
  (`flutter_gemma`) reste à vérifier ;
- pas de tests automatisés pour l'instant.

## Déploiement Web (GitHub Pages)

Le workflow `.github/workflows/deploy.yml` construit l'application Web depuis
`mobile/` et publie la branche `gh-pages` sur push de `main` ou `frontend`.
Voir `mobile/GITHUB_PAGES_CONFIG.md`.
