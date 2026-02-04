#!/bin/bash
# Initialise les fichiers de planification pour une nouvelle session
# Usage : ./init-session.sh [nom-du-projet]

set -e

PROJECT_NAME="${1:-projet}"
DATE=$(date +%Y-%m-%d)

echo "Initialisation des fichiers de planification pour : $PROJECT_NAME"

# Crée task_plan.md s'il n'existe pas
if [ ! -f "task_plan.md" ]; then
    cat > task_plan.md << 'EOF'
# Plan de Tâche : [Brève Description]

## Objectif
[Une phrase décrivant l'état final]

## Phase Actuelle
Phase 1

## Phases

### Phase 1 : Exigences & Découverte
- [ ] Comprendre l'intention de l'utilisateur
- [ ] Identifier les contraintes
- [ ] Documenter dans findings.md
- **Statut :** in_progress

### Phase 2 : Planification & Structure
- [ ] Définir l'approche
- [ ] Créer la structure du projet
- **Statut :** pending

### Phase 3 : Implémentation
- [ ] Exécuter le plan
- [ ] Écrire dans les fichiers avant d'exécuter
- **Statut :** pending

### Phase 4 : Tests & Vérification
- [ ] Vérifier que les exigences sont remplies
- [ ] Documenter les résultats des tests
- **Statut :** pending

### Phase 5 : Livraison
- [ ] Revoir les sorties
- [ ] Livrer à l'utilisateur
- **Statut :** pending

## Décisions Prises
| Décision | Justification |
|----------|---------------|

## Erreurs Rencontrées
| Erreur | Résolution |
|--------|------------|
EOF
    echo "Créé task_plan.md"
else
    echo "task_plan.md existe déjà, ignoré"
fi

# Crée findings.md s'il n'existe pas
if [ ! -f "findings.md" ]; then
    cat > findings.md << 'EOF'
# Découvertes & Décisions

## Exigences
-

## Découvertes de Recherche
-

## Décisions Techniques
| Décision | Justification |
|----------|---------------|

## Problèmes Rencontrés
| Problème | Résolution |
|----------|------------|

## Ressources
-
EOF
    echo "Créé findings.md"
else
    echo "findings.md existe déjà, ignoré"
fi

# Crée progress.md s'il n'existe pas
if [ ! -f "progress.md" ]; then
    cat > progress.md << EOF
# Journal de Progression

## Session : $DATE

### Statut Actuel
- **Phase :** 1 - Exigences & Découverte
- **Commencé :** $DATE

### Actions Entreprises
-

### Résultats des Tests
| Test | Attendu | Actuel | Statut |
|------|---------|--------|--------|

### Erreurs
| Erreur | Résolution |
|--------|------------|
EOF
    echo "Créé progress.md"
else
    echo "progress.md existe déjà, ignoré"
fi

echo ""
echo "Fichiers de planification initialisés !"
echo "Fichiers : task_plan.md, findings.md, progress.md"
