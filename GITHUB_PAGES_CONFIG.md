# Configuration GitHub Pages - CareerGuide AI

## ✅ Corrections appliquées

1. **Fichier `index.html`** : Changé `<base href="/">` vers `<base href="/CareerGuide-AI/">`
2. **Fichier `web/index.html`** : Changé `<base href="$FLUTTER_BASE_HREF">` vers `<base href="/CareerGuide-AI/">`
3. **Fichier `build/web/index.html`** : Changé `<base href="/">` vers `<base href="/CareerGuide-AI/">`
4. **Fichier `.nojekyll`** : Créé à la racine et dans `build/web/` pour éviter que Jekyll traite les dossiers avec underscore
5. **Workflow GitHub Actions** : Créé `.github/workflows/deploy.yml` pour un déploiement automatique

## 🚀 Configuration GitHub Pages

### Étape 1: Configurer le repository
1. Allez à `Settings` → `Pages`
2. Sous "Build and deployment" → "Source"
3. Sélectionnez `Deploy from a branch`
4. Sélectionnez la branche `gh-pages` (créée par le workflow)
5. Cliquez sur "Save"

### Étape 2: Push vos modifications
```bash
git add -A
git commit -m "fix: Configure GitHub Pages deployment with correct base href"
git push origin frontend
```

### Étape 3: Vérifier le déploiement
1. Allez à votre repository → "Actions"
2. Vous devriez voir le workflow "Deploy to GitHub Pages" en cours d'exécution
3. Une fois complété, votre app sera disponible à:
   ```
   https://aziliz-kabore.github.io/CareerGuide-AI/
   ```

## 📋 Fichiers modifiés
- ✅ `index.html`
- ✅ `web/index.html`
- ✅ `build/web/index.html`
- ✅ `.nojekyll` (créé)
- ✅ `build/web/.nojekyll` (créé)
- ✅ `.github/workflows/deploy.yml` (créé)

## 🔧 Commandes utiles

**Build local pour tester:**
```bash
flutter build web --base-href=/CareerGuide-AI/ --release
```

**Nettoyer et rebuild:**
```bash
flutter clean
flutter pub get
flutter build web --base-href=/CareerGuide-AI/ --release
```

## ⚠️ Troubleshooting

Si vous voyez encore des erreurs 404:
1. Vérifiez que `build/web/index.html` a le bon base href
2. Attendez 5-10 minutes pour que GitHub Pages cache se mette à jour
3. Videz le cache du navigateur (Ctrl+Shift+Delete)

