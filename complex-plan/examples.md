# Exemples : Planification avec Fichiers en Action

## Exemple 1 : Tâche de Recherche

**Demande de l'Utilisateur :** "Recherchez les bienfaits de l'exercice matinal et écrivez un résumé"

### Boucle 1 : Créer le Plan
```bash
Write task_plan.md
```

```markdown
# Plan de Tâche : Recherche sur les Bienfaits de l'Exercice Matinal

## Objectif
Créer un résumé de recherche sur les bienfaits de l'exercice matinal.

## Phases
- [ ] Phase 1 : Créer ce plan ✓
- [ ] Phase 2 : Rechercher et rassembler les sources
- [ ] Phase 3 : Synthétiser les découvertes
- [ ] Phase 4 : Livrer le résumé

## Questions Clés
1. Quels sont les bienfaits physiques pour la santé ?
2. Quels sont les bienfaits mentaux pour la santé ?
3. Quelles études scientifiques supportent cela ?

## Statut
**Actuellement en Phase 1** - Création du plan
```

### Boucle 2 : Recherche
```bash
Read task_plan.md           # Rafraîchir les objectifs
WebSearch "bienfaits exercice matinal"
Write notes.md              # Stocker les découvertes
Edit task_plan.md           # Marquer la Phase 2 terminée
```

### Boucle 3 : Synthétiser
```bash
Read task_plan.md           # Rafraîchir les objectifs
Read notes.md               # Obtenir les découvertes
Write resume_exercice_matinal.md
Edit task_plan.md           # Marquer la Phase 3 terminée
```

### Boucle 4 : Livrer
```bash
Read task_plan.md           # Vérifier la complétion
Deliver resume_exercice_matinal.md
```

---

## Exemple 2 : Tâche de Correction de Bug

**Demande de l'Utilisateur :** "Corrigez le bug de connexion dans le module d'authentification"

### task_plan.md
```markdown
# Plan de Tâche : Corriger le Bug de Connexion

## Objectif
Identifier et corriger le bug empêchant la connexion réussie.

## Phases
- [x] Phase 1 : Comprendre le rapport de bug ✓
- [x] Phase 2 : Localiser le code pertinent ✓
- [ ] Phase 3 : Identifier la cause racine (ACTUEL)
- [ ] Phase 4 : Implémenter le correctif
- [ ] Phase 5 : Tester et vérifier

## Questions Clés
1. Quel message d'erreur apparaît ?
2. Quel fichier gère l'authentification ?
3. Qu'est-ce qui a changé récemment ?

## Décisions Prises
- Le gestionnaire d'auth est dans src/auth/login.ts
- L'erreur se produit dans la fonction validateToken()

## Erreurs Rencontrées
- [Initiale] TypeError : Cannot read property 'token' of undefined
  → Cause racine : objet user non attendu correctement

## Statut
**Actuellement en Phase 3** - Cause racine trouvée, préparation du correctif
```

---

## Exemple 3 : Développement de Fonctionnalité

**Demande de l'Utilisateur :** "Ajoutez un bouton de mode sombre à la page des paramètres"

### Le Pattern des 3 Fichiers en Action

**task_plan.md :**
```markdown
# Plan de Tâche : Bouton de Mode Sombre

## Objectif
Ajouter un bouton de mode sombre fonctionnel aux paramètres.

## Phases
- [x] Phase 1 : Rechercher le système de thème existant ✓
- [x] Phase 2 : Concevoir l'approche d'implémentation ✓
- [ ] Phase 3 : Implémenter le composant de toggle (ACTUEL)
- [ ] Phase 4 : Ajouter la logique de changement de thème
- [ ] Phase 5 : Tester et peaufiner

## Décisions Prises
- Utilisation des propriétés CSS personnalisées pour le thème
- Stockage de la préférence dans localStorage
- Composant de toggle dans SettingsPage.tsx

## Statut
**Actuellement en Phase 3** - Construction du composant de toggle
```

**notes.md :**
```markdown
# Notes : Implémentation du Mode Sombre

## Système de Thème Existant
- Situé dans : src/styles/theme.ts
- Utilise : propriétés CSS personnalisées
- Thèmes actuels : light uniquement

## Fichiers à Modifier
1. src/styles/theme.ts - Ajouter les couleurs du thème sombre
2. src/components/SettingsPage.tsx - Ajouter le toggle
3. src/hooks/useTheme.ts - Créer un nouveau hook
4. src/App.tsx - Envelopper avec ThemeProvider

## Décisions de Couleur
- Fond sombre : #1a1a2e
- Surface sombre : #16213e
- Texte sombre : #eaeaea
```

**dark_mode_implementation.md :** (livrable)
```markdown
# Implémentation du Mode Sombre

## Changements Effectués

### 1. Ajout des couleurs du thème sombre
Fichier : src/styles/theme.ts
...

### 2. Création du hook useTheme
Fichier : src/hooks/useTheme.ts
...
```

---

## Exemple 4 : Pattern de Récupération d'Erreur

Quand quelque chose échoue, NE PAS le cacher :

### Avant (Faux)
```
Action : Lire config.json
Erreur : Fichier non trouvé
Action : Lire config.json  # Retry silencieux
Action : Lire config.json  # Un autre retry
```

### Après (Correct)
```
Action : Lire config.json
Erreur : Fichier non trouvé

# Mettre à jour task_plan.md :
## Erreurs Rencontrées
- config.json non trouvé → Création d'une config par défaut

Action : Écrire config.json (config par défaut)
Action : Lire config.json
Succès !
```

---

## Le Pattern Lire-Avant-De-Décider

**Relisez toujours votre plan avant les décisions majeures :**

```
[De nombreux appels d'outils se sont produits...]
[Le contexte devient long...]
[L'objectif original pourrait être oublié...]

→ Lire task_plan.md          # Cela ramène les objectifs dans l'attention !
→ Maintenant prendre la décision       # Les objectifs sont frais dans le contexte
```

C'est pourquoi Manus peut gérer ~50 appels d'outils sans perdre le fil. Le fichier de plan agit comme un mécanisme de "rafraîchissement des objectifs".
