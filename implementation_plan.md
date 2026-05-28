# Refonte du flux : Questionnaire instantané et structuré

## Objectif
Supprimer le temps d'attente avant les questions. Remplacer la zone de texte libre par un vrai questionnaire interactif (3 à 5 questions) avec des choix de réponses et une option "Autre" pour la saisie libre, permettant de récolter les compétences, passions et désirs futurs de l'élève.

## User Review Required
> [!IMPORTANT]
> Pour que le passage aux questions soit **instantané (sans pause)**, l'IA ne peut pas générer les questions en temps réel (ce qui prendrait 3 à 5 secondes).
> 
> Voici la solution proposée :
> 1. **Questions pré-définies intelligentes :** Dès que l'élève choisit son niveau, on affiche instantanément un formulaire de 4 questions ciblées :
>    - *Q1 (Passions) :* Qu'est-ce qui vous attire le plus ? (Options : Technologie, Art, Sciences, etc. + Autre)
>    - *Q2 (Compétences) :* Dans quel domaine êtes-vous le plus à l'aise ? (Options : Calcul/Logique, Rédaction, Créativité, etc. + Autre)
>    - *Q3 (Désirs) :* Quel type d'environnement de travail visez-vous ? (Options : Bureau, Terrain, Laboratoire, etc. + Autre)
>    - *Q4 (Objectif) :* Quel est votre but principal ? (Options : Créer une entreprise, Aider les autres, Innover, etc. + Autre)
> 2. **Saisie "Autre" :** Pour chaque question, si l'élève choisit "Autre", un champ de texte s'ouvre pour qu'il tape sa propre réponse.
> 3. **Calcul IA et Radar :** Une fois le questionnaire soumis, l'animation du radar holographique se lance pendant que l'IA analyse toutes ces réponses combinées pour générer le Top 3-5 et son texte d'analyse.
> 
> *Est-ce que cette approche avec un questionnaire structuré (choix multiples + champ Autre) vous convient pour éviter le temps d'attente initial ?*

## Proposed Changes

### [MODIFY] [Recommendations.tsx](file:///c:/Users/azili/OneDrive/Desktop/CareerGuide/Web_app/src/pages/Recommendations.tsx)
- Suppression de l'état `ai-thinking` (le premier radar).
- Le passage de `level-select` à `questions` se fera instantanément.
- Remplacement du simple `textarea` par un composant de questionnaire (3-4 questions).
- Chaque question aura des boutons pour les choix multiples, et un bouton "Autre" qui affichera un `<input type="text">`.
- Lors de la soumission, toutes les réponses sont concaténées en une seule chaîne (ex: "Passions: Technologie, Compétences: Logique...").
- L'état `calculating` affichera le radar holographique. Pendant ce temps, on appelle `generateAIRecommendationAnalysis` et `getDynamicRecommendations` simultanément avec les réponses de l'utilisateur.

### [MODIFY] [localCareerBackend.ts](file:///c:/Users/azili/OneDrive/Desktop/CareerGuide/Web_app/src/services/localCareerBackend.ts)
- Mise à jour du prompt de `generateAIRecommendationAnalysis` pour qu'il prenne en entrée les réponses exactes du questionnaire et fasse l'analyse globale à la fin, plutôt que de poser des questions.
