# 📚 Guide de Démarrage - CareerGuide IA

Bienvenue dans CareerGuide, votre conseiller d'orientation intelligent basé sur l'IA Gemma, conçu pour fonctionner avec ou sans connexion internet.

## 🖥️ Installation sur PC

### 1. Lancer le Backend (Serveur IA)
Le backend gère l'intelligence artificielle et la base de données des écoles.
- Ouvrez un terminal dans `CareerGuide-AI-backend/tania/backend`.
- Activez votre environnement virtuel : `..\..\.venv\Scripts\activate`.
- Lancez le serveur : `uvicorn app.main:app --reload`.
- *Note : Le premier lancement charge le modèle Gemma en mémoire.*

### 2. Lancer le Frontend (Application Web)
- Ouvrez un autre terminal dans `Web_app`.
- Installez les dépendances : `npm install`.
- Lancez l'application : `npm run dev`.
- L'application sera accessible sur `http://localhost:5173`.

---

## 📱 Utilisation sur Téléphone (Mode Mobile)

CareerGuide est une **PWA (Progressive Web App)**, ce qui signifie qu'elle s'installe comme une application normale sans passer par le Play Store.

1. **Connectez votre téléphone et votre PC sur le même réseau Wi-Fi.**
2. Sur votre PC, repérez votre adresse IP locale (ex: `192.168.1.15`).
3. Sur votre téléphone, ouvrez Chrome et tapez : `http://192.168.1.15:5173`.
4. **Installation** : Cliquez sur les trois petits points de Chrome et choisissez **"Ajouter à l'écran d'accueil"**.
5. L'icône CareerGuide apparaîtra sur votre téléphone. Vous pourrez l'ouvrir même en mode avion !

---

## 🤖 Fonctionnalités IA

1. **Configuration du Profil** : Remplissez vos passions et matières préférées. Ces données sont stockées sur votre appareil.
2. **Recommandations** : Tania analyse votre profil et suggère des filières au Burkina Faso avec un score de match.
3. **Chat avec Tania** : Posez des questions comme "Quels débouchés pour la série D ?" ou "Aide-moi à choisir mon école". Tania vous répondra de manière intelligente et personnalisée.

---

## 🔌 Mode Hors-ligne (Offline-First)

L'application est conçue pour les zones à faible connectivité :
- **Caching** : Une fois ouverte une première fois, l'app se charge instantanément sans internet.
- **Données Locales** : Vos conversations et votre profil restent sur votre téléphone.
- **IA Locale** : Le modèle Gemma tourne sur votre machine, garantissant une confidentialité totale.

---

*Développé avec soin pour l'avenir des étudiants.*
