# Roadmap des Modifications - CareerGuide IA

Ce document résume les modifications stratégiques effectuées pour transformer CareerGuide en une application autonome, performante et "Offline-First".

## 1. Intelligence Artificielle (Gemma)
- **Migration vers Mediapipe GenAI** : Le moteur IA a été basculé de `transformers` (lourd et dépendant du cloud) vers **Mediapipe**, permettant une exécution ultra-rapide en local (offline).
- **Modèle Utilisé** : Gemma 3 (1.1B) quantizé en 4-bit (`gemma3-1b-it-int4.task`), optimisé pour les ordinateurs portables et les mobiles.
- **Réponses Dynamiques** : Suppression de la logique de réponses fixes. L'IA analyse désormais le profil complet de l'étudiant (matières, intérêts, niveau) pour donner des conseils uniques.

## 2. Frontend Web & Mobile (PWA)
- **Design "App-like"** : Refonte de l'interface avec une barre de navigation basse (Bottom Nav) pour une expérience identique à une application native sur téléphone.
- **Support Offline (PWA)** : Configuration complète de `VitePWA`. L'application peut être installée sur l'écran d'accueil et s'ouvre sans internet.
- **Gestion d'État (Zustand)** : Implémentation d'une sauvegarde locale automatique de toutes les données utilisateur.
- **Indicateur de Connexion** : Ajout d'un témoin visuel temps-réel (Vert/Orange) pour l'état de la connexion.

## 3. Connectivité Backend-Frontend
- **Intégration API** : Liaison des pages de **Chat** et de **Recommandations** avec le serveur FastAPI.
- **Analyse Personnalisée** : Tania (l'IA) génère désormais un paragraphe d'analyse pour expliquer *pourquoi* telle filière est suggérée.
- **Sécurité CORS** : Activation des middlewares pour permettre la communication fluide entre le frontend (5173/5174) et le backend (8000).

## 4. Corrections Techniques
- **Tailwind 4** : Correction de la configuration du plugin Vite qui empêchait le rendu des styles.
- **TypeScript** : Correction de toutes les erreurs de typage dans le store et les composants de profil.
- **Poids des Images** : Correction du bug qui rendait les images gigantesques.

## 5. Prochaines Étapes
- [ ] Exportation des recommandations en PDF.
- [ ] Ajout d'une carte interactive des établissements au Burkina Faso.
- [ ] Support multilingue (langues locales).
