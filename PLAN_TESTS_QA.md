# PLAN DE TEST QA - CareerGuide AI

Ce document détaille la stratégie et les étapes de test pour garantir la qualité, la sécurité et la fiabilité de l'application.

## 1. Scope des tests
*   **Frontend (Flutter)** : Interface utilisateur, navigation, formulaires, affichage dynamique.
*   **Backend (FastAPI/PostgreSQL)** : Authentification, APIs, logique métier, base de données.
*   **Chatbot IA** : Réponses et pertinence (système RAG & LLM).
*   **Qualité & Performance** : Android bas de gamme, mode sombre/clair, latence.

## 2. Étapes de test à suivre

### Étape A : Validation de la Connexion Backend
1. Vérifier que FastAPI est bien lancé sur le port 8000.
2. Tester la santé du backend (`curl http://localhost:8000/`).
3. Vérifier la connexion à PostgreSQL via SQLAlchemy.

### Étape B : Tests Fonctionnels Critiques
1. **Authentification (Passwordless)** : 
   - Inscription d'un nouvel élève (Nom, Prénom, Tel, Âge).
   - Tentative de reconnexion avec le même téléphone.
2. **Profil Élève** : 
   - Mise à jour du profil complet (Classe, Série, Ville, Intérêts).
   - Vérification de la persistance en base de données.
3. **Filtres Académiques** :
   - Tester le cloisonnement : un élève de 3ème ne doit voir que des lycées. Un élève de Terminale ne doit voir que des universités/instituts.

### Étape C : Tests du Chatbot IA
1. **Questions contextuelles** : Poser des questions sur l'orientation en utilisant le prénom et la classe de l'élève.
2. **Gestion des erreurs** : Tester des entrées invalides, vide, ou questions hors-sujet.
3. **Performance (IA)** : Tester le temps de réponse du chat.

### Étape D : Tests de Compatibilité & Performance
1. **Mode Sombre** : Vérifier la lisibilité sur tous les écrans.
2. **Android bas de gamme** : Tester la fluidité du défilement dans les listes d'écoles.
3. **Notifications** : Vérifier que le toggle (switch) dans les paramètres active/désactive bien les pop-ups (SnackBars).

### Étape E : Tests de Sécurité (Sécurité applicative)
1. **Protection des routes** : Tenter d'accéder à des APIs sans ID utilisateur valide.
2. **Injection** : Tester les entrées utilisateur pour empêcher les injections SQL ou XSS.
3. **Données personnelles** : Vérifier qu'aucune info confidentielle n'est exposée dans les logs.

---
*Note pour l'utilisateur : Une fois que tu auras libéré de l'espace, lance le backend (`uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`), puis envoie-moi ce plan pour démarrer les tests un par un.*
