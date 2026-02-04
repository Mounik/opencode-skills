---
name: git-essentials
description: Guide pratique pour Git - Le système de contrôle de version distribué. Maîtrisez les commandes essentielles, les branches, les commits et la collaboration. Utilisez pour versionner du code et collaborer efficacement.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: version-control
---

# Git Essentials

## Ce que je fais

Guide pratique pour Git, le système de contrôle de version distribué open-source. Ce skill couvre les commandes essentielles, la gestion des branches, les commits et les meilleures pratiques pour versionner du code et collaborer efficacement.

Aide à initialiser un nouveau repository Git
Cloner un repository existant
Créer et gérer des commits
Travailler avec des branches
Fusionner du code (merge)
Collaborer avec d'autres développeurs
Résoudre des conflits de merge
Gérer l'historique des versions

## Quand m'utiliser

- Initialiser un nouveau repository Git
- Cloner un repository existant
- Créer et gérer des commits
- Travailler avec des branches
- Fusionner du code (merge)
- Collaborer avec d'autres développeurs
- Résoudre des conflits de merge
- Gérer l'historique des versions

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière version des commandes Git et des fonctionnalités
2. Vérifiez les changements récents dans la documentation Git officielle
3. Fournissez des exemples à jour basés sur les meilleures pratiques Git

---

## Installation de Git

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install git

# Vérifier l'installation
git --version
```

### macOS

```bash
# Via Homebrew
brew install git

# Ou via Xcode Command Line Tools
xcode-select --install
```

### Windows

```bash
# Télécharger depuis https://git-scm.com/download/win
# Ou via Chocolatey
choco install git
```

### Configuration Initiale

```bash
# Configurer le nom d'utilisateur
git config --global user.name "Votre Nom"

# Configurer l'email
git config --global user.email "votre@email.com"

# Configurer l'éditeur par défaut
git config --global core.editor "vim"
# ou
git config --global core.editor "code --wait"

# Vérifier la configuration
git config --list
```

---

## Commandes Essentielles

### Initialiser un Repository

```bash
# Créer un nouveau repository
git init

# Initialiser dans un dossier spécifique
git init mon-projet

# Cloner un repository existant
git clone https://github.com/utilisateur/repo.git

# Cloner dans un dossier spécifique
git clone https://github.com/utilisateur/repo.git mon-dossier

# Cloner une branche spécifique
git clone -b branche https://github.com/utilisateur/repo.git
```

### Vérifier le Statut

```bash
# Voir le statut du working directory
git status

# Statut court
git status -s
# ou
git status --short

# Voir les différences
git diff

# Voir les différences staged
git diff --staged
# ou
git diff --cached
```

### Ajouter des Fichiers

```bash
# Ajouter un fichier spécifique
git add fichier.txt

# Ajouter tous les fichiers
git add .

# Ajouter tous les fichiers modifiés
git add -A
# ou
git add --all

# Ajouter de manière interactive
git add -i

# Ajouter avec patch (par morceaux)
git add -p
```

### Créer des Commits

```bash
# Commit avec message
git commit -m "Message du commit"

# Commit et add en une seule commande
git commit -am "Message du commit"

# Commit avec description détaillée
git commit -m "Titre" -m "Description détaillée"

# Modifier le dernier commit
git commit --amend -m "Nouveau message"

# Modifier le dernier commit sans changer le message
git commit --amend --no-edit
```

### Voir l'Historique

```bash
# Log simple
git log

# Log condensé
git log --oneline

# Log avec graphique
git log --oneline --graph

# Log d'un fichier spécifique
git log fichier.txt

# Log avec statistiques
git log --stat

# Log avec statistiques
git log --oneline --decorate --graph --all

# Voir les 5 derniers commits
git log -5

# Log avec format personnalisé
git log --pretty=format:"%h - %an, %ar : %s"
```

---

## Gestion des Branches

### Créer et Switcher

```bash
# Lister les branches
git branch

# Lister toutes les branches (locales et distantes)
git branch -a

# Créer une nouvelle branche
git branch nouvelle-branche

# Switcher vers une branche
git checkout nouvelle-branche
# ou (Git 2.23+)
git switch nouvelle-branche

# Créer et switcher en une commande
git checkout -b nouvelle-branche
# ou (Git 2.23+)
git switch -c nouvelle-branche

# Créer une branche depuis une autre
git checkout -b feature-branch develop
```

### Renommer et Supprimer

```bash
# Renommer la branche courante
git branch -m nouveau-nom

# Renommer une autre branche
git branch -m ancien-nom nouveau-nom

# Supprimer une branche locale
git branch -d branche-a-supprimer

# Forcer la suppression
git branch -D branche-a-supprimer

# Supprimer une branche distante
git push origin --delete branche-a-supprimer
```

---

## Fusion et Rebase

### Merge

```bash
# Fusionner une branche dans la branche courante
git merge feature-branch

# Fusionner sans fast-forward
git merge --no-ff feature-branch

# Fusionner en squash
git merge --squash feature-branch
```

### Rebase

```bash
# Rebaser la branche courante sur main
git rebase main

# Rebaser interactivement
git rebase -i HEAD~3

# Continuer après résolution de conflits
git rebase --continue

# Sauter un commit
git rebase --skip

# Annuler le rebase
git rebase --abort
```

---

## Gestion des Remotes

### Configurer les Remotes

```bash
# Voir les remotes
git remote -v

# Ajouter un remote
git remote add origin https://github.com/utilisateur/repo.git

# Renommer un remote
git remote rename origin destination

# Supprimer un remote
git remote remove origin

# Modifier l'URL d'un remote
git remote set-url origin https://nouvelle-url.git
```

### Synchroniser

```bash
# Récupérer les changements
git fetch

# Récupérer depuis un remote spécifique
git fetch origin

# Pull (fetch + merge)
git pull

# Pull avec rebase
git pull --rebase

# Pull une branche spécifique
git pull origin main

# Pousser les changements
git push

# Pousser une nouvelle branche
git push -u origin nouvelle-branche

# Ou avec upstream
git push --set-upstream origin nouvelle-branche

# Forcer le push (attention!)
git push --force

# ou plus sûr
git push --force-with-lease
```

---

## Résolution de Conflits

### Identifier les Conflits

```bash
# Voir les fichiers en conflit
git status

# Voir les détails des conflits
git diff

# Voir les conflits dans un fichier spécifique
git diff fichier-en-conflit.txt
```

### Résoudre les Conflits

```bash
# 1. Éditer les fichiers en conflit
# 2. Supprimer les marqueurs <<<<<<< ======= >>>>>>>

# 3. Garder les changements souhaités

# Ajouter les fichiers résolus
git add fichier-resolu.txt

# Continuer le merge
git commit

# Ou annuler le merge
git merge --abort

# Ou annuler le rebase
git rebase --abort
```

---

## Commandes Utiles

### Stash (Mettre de côté)

```bash
# Mettre de côté les changements
git stash

# Mettre de côté avec message
git stash push -m "message"

# Voir la liste des stash
git stash list

# Appliquer le dernier stash
git stash pop

# Appliquer sans supprimer
git stash apply

# Appliquer un stash spécifique
git stash apply stash@{2}

# Supprimer le dernier stash
git stash drop

# Vider tous les stash
git stash clear
```

### Reset (Annuler des changements)

```bash
# Unstage un fichier (garder les modifications)
git reset HEAD fichier.txt

# Unstage tous les fichiers
git reset HEAD

# Annuler les modifications d'un fichier
git checkout -- fichier.txt
# ou (Git 2.23+)
git restore fichier.txt

# Reset soft (garder les changements staged)
git reset --soft HEAD~1

# Reset mixed (défaut - unstage mais garder les modifs)
git reset HEAD~1

# Reset hard (supprimer les changements - ATTENTION!)
git reset --hard HEAD~1
```

### Tag (Versions)

```bash
# Lister les tags
git tag

# Créer un tag annoté
git tag -a v1.0.0 -m "Version 1.0.0"

# Créer un tag léger
git tag v1.0.0

# Créer un tag sur un commit spécifique
git tag -a v1.0.0 abc123 -m "Version 1.0.0"

# Pousser un tag spécifique
git push origin v1.0.0

# Pousser tous les tags
git push origin --tags

# Supprimer un tag local
git tag -d v1.0.0

# Supprimer un tag distant
git push origin --delete v1.0.0
```

### Cherry-pick

```bash
# Appliquer un commit spécifique
git cherry-pick abc123

# Cherry-pick sans commit
git cherry-pick -n abc123

# Cherry-pick plusieurs commits
git cherry-pick abc123 def456

# Annuler un cherry-pick
git cherry-pick --abort
```

---

## Workflow Git Flow

### Branches Principales

- **main/master** : Code en production
- **develop** : Branche de développement
- **feature/*** : Nouvelles fonctionnalités
- **release/*** : Préparation des releases
- **hotfix/*** : Corrections urgentes

### Exemple de Workflow

```bash
# 1. Créer une branche feature
git checkout -b feature/nouvelle-fonctionnalite develop

# 2. Développer et commiter
git add .
git commit -m "feat: ajouter nouvelle fonctionnalité"

# 3. Pousser la branche
git push -u origin feature/nouvelle-fonctionnalite

# 4. Créer une Pull Request (sur GitHub/GitLab)

# 5. Après review, merger dans develop
git checkout develop
git merge --no-ff feature/nouvelle-fonctionnalite

# 6. Supprimer la branche feature
git branch -d feature/nouvelle-fonctionnalite
git push origin --delete feature/nouvelle-fonctionnalite

# 7. Pousser develop
git push origin develop
```

---

## Bonnes Pratiques

1. **Commiter souvent** avec des messages clairs
2. **Utiliser des branches** pour chaque fonctionnalité
3. **Faire des revues de code** via Pull/Merge Requests
4. **Ne jamais committer sur main** directement
5. **Résoudre les conflits** avant de pousser
6. **Utiliser .gitignore** pour les fichiers générés
7. **Faire des commits atomiques** (une chose par commit)
8. **Utiliser des messages de commit conventionnels** (feat:, fix:, docs:, etc.)

---

## Messages de Commit Conventionnels

```
feat:     Nouvelle fonctionnalité
fix:      Correction de bug
docs:     Documentation uniquement
style:    Formatage, point-virgules manquants, etc.
refactor: Refactoring du code
test:     Ajout ou correction de tests
chore:    Maintenance, dépendances, etc.
```

### Exemples

```bash
git commit -m "feat: ajouter authentification utilisateur"
git commit -m "fix: corriger bug de connexion"
git commit -m "docs: mettre à jour README"
git commit -m "refactor: simplifier fonction de calcul"
git commit -m "test: ajouter tests unitaires"
```

---

## Fichier .gitignore

### Exemple pour Node.js

```gitignore
# Dépendances
node_modules/

# Logs
logs
*.log
npm-debug.log*

# Environnement
.env
.env.local
.env.local

# Build
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### Exemple pour Python

```gitignore
# Byte-compiled
__pycache__/
*.py[cod]
*$py.class

# Environnement virtuel
venv/
env/
ENV/

# Distribution
build/
dist/
*.egg-info/

# Tests
.pytest_cache/
.coverage

# IDE
.vscode/
.idea/
*.swp
*.swo
```

---

## Ressources Officielles

- [Documentation Git](https://git-scm.com/doc)
- [Pro Git Book](https://git-scm.com/book)
- [Git Cheat Sheet](https://git-scm.com/docs/gittutorial)
- [GitHub Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

---

*Ce skill utilise la documentation officielle Git via Context7 MCP - Février 2025*