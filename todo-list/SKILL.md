---
name: todo-list
description: Planification structurée des tâches avec des décompositions claires, des dépendances et des critères de vérification
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: planning
---

# Liste de Tâches (Todo List)

## Ce que je fais

- Framework pour décomposer le travail en tâches claires et actionnables
- Définition de critères de vérification ("Done")
- Planification structurée avec dépendances
- Suivi de l'avancement et terminaison
- Priorisation des tâches basée sur l'impact

## Quand m'utiliser

- Implémentation de nouvelles fonctionnalités
- Refactoring de code existant
- Tout travail en plusieurs étapes
- Gestion de projets complexes
- Coordination d'équipes

## Instructions

1. **Clarifiez les objectifs** avant de commencer
2. **Décomposez en petites tâches** - Chaque tâche doit prendre 2-5 minutes
3. **Ajoutez des critères de vérification** clairs et actionnables
4. **Identifiez les dépendances** entre les tâches
5. **Priorisez** basé sur l'impact et la criticité

## Principes de Décomposition des Tâches

### 1. Tâches Petites et Ciblées
- Chaque tâche devrait prendre 2-5 minutes
- Un résultat clair par tâche
- Indépendamment vérifiable
- Un seul aspect du problème par tâche

### 2. Vérification Claire
- Comment savez-vous que c'est terminé ?
- Que pouvez-vous vérifier/tester ?
- Quelle est la sortie attendue ?

### 3. Ordre Logique
- Dépendances identifiées
- Travail parallèle quand possible
- Chemin critique mis en évidence
- **Phase X : La vérification est toujours la DERNIÈRE !**

### 4. Nommage Dynamique à la Racine du Projet
- Les fichiers de plan sont sauvegardés comme `{task-slug}.md` dans la RACINE DU PROJET
- Le nom est dérivé de la tâche (ex: "add auth" → `auth-feature.md`)
- **JAMAIS** à l'intérieur de `.claude/`, `docs/`, ou dossiers temporaires

## Principes de Planification

### Principe 1 : Gardez-le COURT

| ❌ Faux | ✅ Juste |
|---------|----------|
| 50 tâches avec sous-sous-tâches | 5-10 tâches claires max |
| Chaque micro-étape listée | Seuls les éléments actionnables |
| Descriptions verboses | Une ligne par tâche |

> **Règle :** Si la todo-list fait plus d'une page, c'est trop long. Simplifiez.

---

### Principe 2 : Soyez SPÉCIFIQUE, Pas Générique

| ❌ Faux | ✅ Juste |
|---------|----------|
| "Configurer le projet" | "Exécuter `npx create-next-app`" |
| "Ajouter l'authentification" | "Installer next-auth, créer `/api/auth/[...nextauth].ts`" |
| "Styliser l'UI" | "Ajouter les classes Tailwind à `Header.tsx`" |

> **Règle :** Chaque tâche devrait avoir un résultat clair et vérifiable.

---

### Principe 3 : Contenu Dynamique Basé sur le Type de Projet

**Pour NOUVEAU PROJET :**
- Quelle stack technique ? (décider d'abord)
- Quel est le MVP ? (fonctionnalités minimales)
- Quelle est la structure de fichiers ?

**Pour AJOUT DE FONCTIONNALITÉ :**
- Quels fichiers sont affectés ?
- Quelles dépendances sont nécessaires ?
- Comment vérifier que ça fonctionne ?

**Pour CORRECTION DE BUG :**
- Quelle est la cause racine ?
- Quel fichier/ligne modifier ?
- Comment tester le correctif ?

---

### Principe 4 : Les Scripts sont Spécifiques au Projet

> 🔴 **NE PAS copier-coller les commandes de scripts. Choisir en fonction du type de projet.**

| Type de Projet | Scripts Pertinents |
|----------------|-------------------|
| Frontend/React | `ux_audit.py`, `accessibility_checker.py` |
| Backend/API | `api_validator.py`, `security_scan.py` |
| Mobile | `mobile_audit.py` |
| Base de données | `schema_validator.py` |
| Full-stack | Mix des ci-dessus selon ce que vous avez touché |

**Faux :** Ajouter tous les scripts à chaque plan
**Juste :** Seuls les scripts pertinents pour CETTE tâche

---

### Principe 5 : La Vérification est Simple

| ❌ Faux | ✅ Juste |
|---------|----------|
| "Vérifier que le composant fonctionne correctement" | "Exécuter `npm run dev`, cliquer sur le bouton, voir le toast" |
| "Tester l'API" | "curl localhost:3000/api/users retourne 200" |
| "Vérifier les styles" | "Ouvrir le navigateur, vérifier que le toggle dark mode fonctionne" |

---

## Structure du Plan (Flexible, Pas Fixe !)

```markdown
# [Nom de la Tâche]

## Objectif
Une phrase : Que construisons-nous / corrigeons-nous ?

## Tâches
- [ ] Tâche 1 : [Action spécifique] → Vérifier : [Comment vérifier]
- [ ] Tâche 2 : [Action spécifique] → Vérifier : [Comment vérifier]
- [ ] Tâche 3 : [Action spécifique] → Vérifier : [Comment vérifier]

## Terminé Quand
- [ ] [Critères de succès principaux]
```

> **C'est tout.** Pas de phases, pas de sous-sections sauf si vraiment nécessaire.
> Gardez-le minimal. Ajoutez de la complexité seulement quand requis.

## Notes
[Toutes considérations importantes]
```

---

## Bonnes Pratiques (Référence Rapide)

1. **Commencez par l'objectif** - Que construisons-nous / corrigeons-nous ?
2. **Max 10 tâches** - Si plus, décomposer en plusieurs plans
3. **Chaque tâche vérifiable** - Critères de "terminé" clairs
4. **Spécifique au projet** - Pas de templates copiés-collés
5. **Mettre à jour au fur et à mesure** - Marquer `[x]` quand terminé
6. **Documenter** - README avec captures d'écran ou logs
7. **Tests** - Testez manuellement ou automatiquement selon le type de projet

---

## Quand Utiliser

- Nouveau projet from scratch
- Ajout d'une fonctionnalité
- Correction d'un bug (si complexe)
- Refactoring de plusieurs fichiers

---

## Exemples de Plans Complets

### Exemple 1 : Nouveau Projet Next.js

```markdown
# auth-feature

## Objectif
Ajouter l'authentification NextAuth au projet Next.js

## Tâches
- [ ] Installer next-auth et ajouter les dépendances
- [ ] Créer la configuration auth dans le dossier `/api/auth/`
- [ ] Créer les routes API `/api/auth/[...nextauth]/route.ts`
- [ ] Créer les composants UI de connexion
- [ ] Tester le flux d'authentification en local
- [ ] Déployer sur Vercel et tester en staging

## Terminé Quand
- [ ] User peut se connecter avec GitHub/Google
- [ ] User peut se déconnecter
- [ ] Session persiste entre les rechargements
- [ ] Middleware protège les routes protégées
```

### Exemple 2 : Correction de Bug (Backend)

```markdown
# fix-api-timeout

## Objectif
Corriger le timeout sur l'API `/api/users` qui survient sous charge

## Tâches
- [ ] Reproduire le bug localement (charger l'endpoint)
- [ ] Analyser les logs et identifier la cause
- [ ] Ajouter un timeout à la requête HTTP
- [ ] Implémenter une meilleure stratégie (pagination, caching)
- [ ] Écrire des tests unitaires pour le scénario
- [ ] Tester avec des charges élevées

## Terminé Quand
- [ ] L'endpoint retourne 200 en moins de 5s même sous charge
- [ ] Les tests passent avec différentes charges
- [ ] Utilisation mémoire stable
- [ ] Pas d'erreurs dans les logs
```

### Exemple 3 : Refactoring (Frontend)

```markdown
# refactor-state-management

## Objectif
Refactoriser la gestion d'état du store Redux pour utiliser Zustand

## Tâches
- [ ] Installer zustand et les dépendances TypeScript
- [ ] Créer les stores Zustand pour chaque feature
- [ ] Migrer les composants vers les nouveaux stores
- [ ] Supprimer l'ancien code Redux
- [ ] Tester que tous les features fonctionnent encore
- [ ] Mettre à jour la documentation

## Terminé Quand
- [ ] Tous les tests passent
- [ ] Bundle réduit de taille >50%
- [ ] Code plus lisible et maintenable
- [ ] Documentation à jour
```
