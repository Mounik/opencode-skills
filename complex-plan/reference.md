# Référence : Principes d'Ingénierie de Contexte de Manus

Ce skill est basé sur les principes d'ingénierie de contexte de Manus, la société d'agents IA acquise par Meta pour 2 milliards de dollars en décembre 2025.

## Les 6 Principes Manus

### Principe 1 : Concevoir Autour du KV-Cache

> "Le taux de hit du KV-cache est LA métrique la plus importante pour les agents IA en production."

**Statistiques :**
- Ratio de tokens d'entrée à sortie d'environ 100:1
- Tokens en cache : 0,30$/MTok vs Non cachés : 3$/MTok
- Différence de coût de 10x !

**Implémentation :**
- Gardez les préfixes de prompt STABLES (un changement d'un token invalide le cache)
- PAS de timestamps dans les prompts système
- Rendez le contexte APPEND-ONLY avec une sérialisation déterministe

### Principe 2 : Masquer, Ne Pas Supprimer

Ne supprimez pas dynamiquement les outils (casse le KV-cache). Utilisez plutôt le masquage des logits.

**Bonne Pratique :** Utilisez des préfixes d'action cohérents (par ex. `browser_`, `shell_`, `file_`) pour un masquage plus facile.

### Principe 3 : Système de Fichiers comme Mémoire Externe

> "Markdown est ma 'mémoire de travail' sur disque."

**La Formule :**
```
Fenêtre de Contexte = RAM (volatile, limitée)
Système de Fichiers = Disque (persistant, illimité)
```

**La Compression Doit Être Restaurable :**
- Gardez les URLs même si le contenu web est supprimé
- Gardez les chemins de fichiers lors de la suppression du contenu des documents
- Ne perdez jamais le pointeur vers les données complètes

### Principe 4 : Manipuler l'Attention par Récitation

> "Crée et met à jour todo.md tout au long des tâches pour pousser le plan global dans la portée d'attention récente du modèle."

**Problème :** Après ~50 appels d'outils, les modèles oublient les objectifs originaux (effet "perdu au milieu").

**Solution :** Relisez `task_plan.md` avant chaque décision. Les objectifs apparaissent dans la fenêtre d'attention.

```
Début du contexte : [Objectif original - loin, oublié]
...nombreux appels d'outils...
Fin du contexte : [Task_plan.md récemment lu - obtient l'ATTENTION !]
```

### Principe 5 : Garder les Mauvais Tours

> "Laissez les mauvais tours dans le contexte."

**Pourquoi :**
- Les actions échouées avec des stack traces laissent le modèle mettre à jour implicitement ses croyances
- Réduit la répétition des erreurs
- La récupération d'erreur est "l'un des signaux les plus clairs d'un VRAI comportement agentique"

### Principe 6 : Ne Pas Se Faire Few-Shotter

> "L'uniformité engendre la fragilité."

**Problème :** Les paires action-observation répétitives causent la dérive et l'hallucination.

**Solution :** Introduisez une variation contrôlée :
- Variez légèrement les formulations
- Ne copiez-collez pas les patterns aveuglément
- Recalibrez sur les tâches répétitives

---

## Les 3 Stratégies d'Ingénierie de Contexte

Basé sur l'analyse de Lance Martin de l'architecture Manus.

### Stratégie 1 : Réduction de Contexte

**Compaction :**
```
Les appels d'outils ont DEUX représentations :
├── COMPLÈTE : Contenu brut de l'outil (stocké dans le système de fichiers)
└── COMPACTE : Référence/chemin de fichier uniquement

RÈGLES :
- Appliquez la compaction aux résultats d'outil VIEUX (antérieurs)
- Gardez les résultats RÉCENTS COMPLÈTS (pour guider la prochaine décision)
```

**Résumé :**
- Appliqué quand la compaction atteint des rendements décroissants
- Généré en utilisant les résultats d'outil complets
- Crée des objets de résumé standardisés

### Stratégie 2 : Isolation de Contexte (Multi-Agent)

**Architecture :**
```
┌─────────────────────────────────┐
│         AGENT PLANIFICATEUR     │
│  └─ Assigne des tâches aux sous-agents │
├─────────────────────────────────┤
│       GESTIONNAIRE DE CONNAISSANCES    │
│  └─ Examine les conversations       │
│  └─ Détermine le stockage du système de fichiers │
├─────────────────────────────────┤
│      SOUS-AGENTS EXÉCUTEURS      │
│  └─ Effectuent les tâches assignées    │
│  └─ Ont leurs propres fenêtres de contexte │
└─────────────────────────────────┘
```

**Insight Clé :** Manus utilisait initialement `todo.md` pour la planification des tâches mais a constaté que ~33% des actions étaient consacrées à sa mise à jour. Passage à un agent planificateur dédié appelant des sous-agents exécuteurs.

### Stratégie 3 : Déchargement de Contexte

**Conception d'Outil :**
- Utilisez <20 fonctions atomiques au total
- Stockez les résultats complets dans le système de fichiers, pas dans le contexte
- Utilisez `glob` et `grep` pour la recherche
- Divulgation progressive : chargez l'information seulement quand nécessaire

---

## La Boucle Agent

Manus opère dans une boucle continue en 7 étapes :

```
┌─────────────────────────────────────────┐
│  1. ANALYSER LE CONTEXTE                 │
│     - Comprendre l'intention de l'utilisateur │
│     - Évaluer l'état actuel              │
│     - Examiner les observations récentes │
├─────────────────────────────────────────┤
│  2. RÉFLÉCHIR                            │
│     - Devrais-je mettre à jour le plan ? │
│     - Quelle est la prochaine action logique ? │
│     - Y a-t-il des blocages ?            │
├─────────────────────────────────────────┤
│  3. SÉLECTIONNER L'OUTIL                 │
│     - Choisir UN outil                   │
│     - S'assurer que les paramètres sont disponibles │
├─────────────────────────────────────────┤
│  4. EXÉCUTER L'ACTION                    │
│     - L'outil s'exécute dans un bac à sable │
├─────────────────────────────────────────┤
│  5. RECEVOIR L'OBSERVATION               │
│     - Le résultat est ajouté au contexte │
├─────────────────────────────────────────┤
│  6. ITÉRER                               │
│     - Retour à l'étape 1                 │
│     - Continuer jusqu'à complétion       │
├─────────────────────────────────────────┤
│  7. LIVRER LE RÉSULTAT                   │
│     - Envoyer les résultats à l'utilisateur │
│     - Joindre tous les fichiers pertinents │
└─────────────────────────────────────────┘
```

---

## Types de Fichiers Créés par Manus

| Fichier | Objectif | Quand Créé | Quand Mis à Jour |
|---------|----------|------------|------------------|
| `task_plan.md` | Suivi des phases, progression | Début de tâche | Après complétion des phases |
| `findings.md` | Découvertes, décisions | Après CHAQUE découverte | Après avoir vu des images/PDFs |
| `progress.md` | Journal de session, ce qui est fait | Aux points d'arrêt | Tout au long de la session |
| Fichiers de code | Implémentation | Avant exécution | Après erreurs |

---

## Contraintes Critiques

- **Exécution d'Action Unique :** UN appel d'outil par tour. Pas d'exécution parallèle.
- **Le Plan est Requis :** L'agent doit TOUJOURS savoir : objectif, phase actuelle, phases restantes
- **Les Fichiers sont la Mémoire :** Contexte = volatile. Système de fichiers = persistant.
- **Ne Jamais Répéter les Échecs :** Si l'action a échoué, la prochaine action DOIT être différente
- **La Communication est un Outil :** Types de message : `info` (progression), `ask` (bloquant), `result` (terminal)

---

## Statistiques Manus

| Métrique | Valeur |
|----------|--------|
| Appels d'outils moyens par tâche | ~50 |
| Ratio de tokens d'entrée à sortie | 100:1 |
| Prix d'acquisition | 2 milliards de dollars |
| Temps pour atteindre 100M$ de revenus | 8 mois |
| Refontes de framework depuis le lancement | 5 fois |

---

## Citations Clés

> "Fenêtre de contexte = RAM (volatile, limitée). Système de fichiers = Disque (persistant, illimité). Tout ce qui est important est écrit sur disque."

> "if action_failed: next_action != same_action. Suivez ce que vous avez essayé. Mutez l'approche."

> "La récupération d'erreur est l'un des signaux les plus clairs d'un VRAI comportement agentique."

> "Le taux de hit du KV-cache est la métrique la plus importante pour un agent IA en phase de production."

> "Laissez les mauvais tours dans le contexte."

---

## Source

Basé sur la documentation officielle d'ingénierie de contexte de Manus :
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
