---
name: complex-plan
description: Implémente la planification basée sur des fichiers à la manière de Manus pour les tâches complexes. Crée task_plan.md, findings.md et progress.md. À utiliser lors du démarrage de tâches complexes en plusieurs étapes, de projets de recherche, ou de toute tâche nécessitant plus de 5 appels d'outils.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: planning
---

# Complex Plan (Basé sur Fichiers)

## Ce que je fais

- Implémente la planification basée sur des fichiers pour les tâches complexes
- Crée et gère task_plan.md (phases, progression, décisions)
- Crée et gère findings.md (recherche, découvertes)
- Crée et gère progress.md (journal de session, résultats de tests)
- Fournit des templates pour structurer le travail
- À utiliser pour : tâches en plusieurs étapes, projets de recherche, tâches complexes

## Quand m'utiliser

- Tâches en plusieurs étapes (3+ étapes)
- Tâches de recherche
- Construction/création de projets
- Tâches couvrant de nombreux appels d'outils
- Tout ce qui nécessite l'organisation et la planification

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière version des patterns de planification
2. Vérifiez les meilleures pratiques pour la gestion de contexte
3. Fournissez des exemples à jour basés sur les principes Manus
4. Documentez les découvertes et erreurs dans findings.md
5. Mettez à jour le statut dans task_plan.md après chaque phase
6. Relisez le plan avant les décisions majeures
7. Gardez les objectifs dans votre fenêtre d'attention

---

## Le Pattern Central

```
Fenêtre de Contexte = RAM (volatile, limitée)
Système de Fichiers = Disque (persistant, illimité)

→ Tout ce qui est important est écrit sur disque.
```

## Objectifs des Fichiers

| Fichier | Objectif | Quand Mettre à Jour |
|---------|----------|---------------------|
| `task_plan.md` | Phases, progression, décisions | Après chaque phase |
| `findings.md` | Recherche, découvertes | Après CHAQUE découverte |
| `progress.md` | Journal de session, résultats de tests | Tout au long de la session |

## Règles Critiques

### 1. Créer le Plan d'Abord

Ne commencez jamais une tâche complexe sans `task_plan.md`. Non négociable.

### 2. La Règle des 2 Actions

> "Après chaque 2 opérations de vue/navigateur/recherche, sauvegardez IMMÉDIATEMENT les découvertes clés dans des fichiers texte."

Cela empêche l'information visuelle/multimodale d'être perdue.

### 3. Lire Avant de Décider

Avant les décisions majeures, lisez le fichier de plan. Cela garde les objectifs dans votre fenêtre d'attention.

### 4. Mettre à Jour Après l'Action

Après avoir terminé une phase :
- Marquez le statut de la phase : `in_progress` → `complete`
- Journalisez toutes les erreurs rencontrées
- Notez les fichiers créés/modifiés

### 5. Journaliser TOUTES les Erreurs

Chaque erreur va dans le fichier de plan. Cela construit des connaissances et évite les répétitions.

```markdown
## Erreurs Rencontrées
| Erreur | Tentative | Résolution |
|--------|-----------|------------|
| FileNotFoundError | 1 | Configuration par défaut créée |
| API timeout | 2 | Logique de retry ajoutée |
```

### 6. Ne Jamais Répéter les Échecs

```
if action_failed:
    next_action != same_action
```
Suivez ce que vous avez essayé. Mutez l'approche.

---

## Le Protocole d'Erreur des 3 Tentatives

```
TENTATIVE 1 : Diagnostiquer & Corriger
  → Lire l'erreur attentivement
  → Identifier la cause racine
  → Appliquer un correctif ciblé

TENTATIVE 2 : Approche Alternative
  → Même erreur ? Essayez une méthode différente
  → Outil différent ? Bibliothèque différente ?
  → Ne JAMAIS répéter exactement la même action en échec

TENTATIVE 3 : Repenser plus Largement
   → Remettre en question les hypothèses
   → Rechercher des solutions
   → Envisager de mettre à jour le plan

APRÈS 3 ÉCHECS : Escalader vers l'Utilisateur
  → Expliquer ce que vous avez essayé
   → Partager l'erreur spécifique
   → Demander des conseils
```

---

## Matrice de Décision Lire vs Écrire

| Situation | Action | Raison |
|-----------|--------|--------|
| Vient d'écrire un fichier | NE PAS lire | Contenu toujours dans le contexte |
| A vu une image/PDF | Écrire les découvertes MAINTENANT | Multimodal → texte avant perte |
| Le navigateur a retourné des données | Écrire dans un fichier | Les captures d'écran ne persistent pas |
| Début d'une nouvelle phase | Lire le plan/découvertes | Se réorienter si le contexte est vieux |
| Une erreur s'est produite | Lire le fichier pertinent | Besoin de l'état actuel pour corriger |
| Reprise après interruption | Lire tous les fichiers de planification | Récupérer l'état |

---

## Le Test de Redémarrage des 5 Questions

Si vous pouvez répondre à celles-ci, votre gestion de contexte est solide :

| Question | Source de Réponse |
|----------|-------------------|
| Où suis-je ? | Phase actuelle dans task_plan.md |
| Où vais-je ? | Phases restantes |
| Quel est l'objectif ? | Déclaration de l'objectif dans le plan |
| Qu'est-ce que j'ai appris ? | findings.md |
| Qu'est-ce que j'ai fait ? | progress.md |

---

## Où Vont les Fichiers

| Emplacement | Ce qui s'y trouve |
|-------------|-------------------|
| Répertoire du skill (`complex-plan/`) | Modèles, scripts, documents de référence |
| Votre répertoire de projet | `task_plan.md`, `findings.md`, `progress.md` |

Cela garantit que vos fichiers de planification vivent aux côtés de votre code, pas enfouis dans le dossier d'installation du skill.

---

## Modèles

Copiez ces modèles pour commencer :

- [templates/task_plan.md](templates/task_plan.md) — Suivi des phases
- [templates/findings.md](templates/findings.md) — Stockage de la recherche
- [templates/progress.md](templates/progress.md) — Journalisation de session

## Scripts

Scripts d'aide pour l'automatisation :

- `scripts/init-session.sh` — Initialiser tous les fichiers de planification
- `scripts/check-complete.sh` — Vérifier que toutes les phases sont terminées

---

## Sujets Avancés

- **Principes Manus :** Voir [reference.md](reference.md)
- **Exemples Réels :** Voir [examples.md](examples.md)

---

## Anti-Patterns

| Ne pas faire | Faire à la place |
|--------------|------------------|
| Utiliser TodoWrite pour la persistance | Créer un fichier task_plan.md |
| Énoncer les objectifs une fois et oublier | Relire le plan avant les décisions |
| Cacher les erreurs et réessayer silencieusement | Journaliser les erreurs dans le fichier de plan |
| Tout mettre dans le contexte | Stocker le contenu volumineux dans des fichiers |
| Commencer à exécuter immédiatement | Créer le fichier de plan D'ABORD |
| Répéter les actions en échec | Suivre les tentatives, muter l'approche |
| Créer des fichiers dans le répertoire complex-plan/ | Créer des fichiers dans votre projet |