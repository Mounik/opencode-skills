#!/bin/bash
# Vérifie si toutes les phases dans task_plan.md sont terminées
# Sortie 0 si terminé, sortie 1 si incomplet
# Utilisé par le hook Stop pour vérifier la complétion de la tâche

PLAN_FILE="${1:-task_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "ERREUR : $PLAN_FILE non trouvé"
    echo "Impossible de vérifier la complétion sans un plan de tâche."
    exit 1
fi

echo "=== Vérification de Complétion de la Tâche ==="
echo ""

# Compte les phases par statut (utilise -F pour la correspondance de chaîne fixe)
TOTAL=$(grep -c "### Phase" "$PLAN_FILE" || true)
COMPLETE=$(grep -cF "**Statut :** complete" "$PLAN_FILE" || true)
IN_PROGRESS=$(grep -cF "**Statut :** in_progress" "$PLAN_FILE" || true)
PENDING=$(grep -cF "**Statut :** pending" "$PLAN_FILE" || true)

# Défaut à 0 si vide
: "${TOTAL:=0}"
: "${COMPLETE:=0}"
: "${IN_PROGRESS:=0}"
: "${PENDING:=0}"

echo "Total des phases :   $TOTAL"
echo "Terminées :        $COMPLETE"
echo "En cours :         $IN_PROGRESS"
echo "En attente :       $PENDING"
echo ""

# Vérifie la complétion
if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    echo "TOUTES LES PHASES SONT TERMINÉES"
    exit 0
else
    echo "TÂCHE NON TERMINÉE"
    echo ""
    echo "Ne vous arrêtez pas avant que toutes les phases soient terminées."
    exit 1
fi
