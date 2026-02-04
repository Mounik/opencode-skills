---
name: github-essentials
description: Guide complet pour GitHub CLI (gh) et GitHub Actions - gestion de repositories, pull requests, issues, releases et workflows CI/CD
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# GitHub Essentiels

## Ce que je fais

- Guide complet pour GitHub CLI (gh)
- Gestion des repositories GitHub (créer, cloner, lister)
- Gestion des Pull Requests (créer, lister, merger)
- Gestion des Issues (créer, lister, commenter, fermer)
- Création et gestion des Releases
- Gestion des workflows GitHub Actions
- Utilisation des Gists pour partager du code
- Configuration d'alias et options

## Quand m'utiliser

- Configurer GitHub CLI (gh) pour la première fois
- Créer et gérer des repositories GitHub
- Gérer des pull requests (créer, lister, merger)
- Créer et suivre des issues
- Automatiser avec GitHub Actions
- Créer des releases
- Collaborer efficacement sur des projets GitHub

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière documentation de GitHub CLI et GitHub Actions
2. Vérifiez toujours l'authentification avec `gh auth status` avant d'utiliser les commandes
3. Utilisez les workflows YAML modernes avec les dernières versions des actions
4. Préférez l'authentification via navigateur web pour la sécurité
5. Committez toujours le fichier `uv.lock` (si vous utilisez uv) mais pas le dossier `.venv/`

## Installation de GitHub CLI

### Linux
```bash
# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh

# Arch Linux
sudo pacman -S github-cli
```

### macOS
```bash
# Via Homebrew
brew install gh

# Via MacPorts
sudo port install gh
```

### Windows
```powershell
# Via winget
winget install --id GitHub.cli

# Via scoop
scoop install gh

# Via Chocolatey
choco install gh
```

### Vérifier l'installation
```bash
gh --version
```

## Authentification

### Se connecter
```bash
# Authentification interactive (recommandé)
gh auth login

# Authentification via navigateur web
gh auth login --web

# Authentification avec token depuis un fichier
gh auth login --with-token < mon-token.txt

# Authentification GitHub Enterprise
gh auth login --hostname github.enterprise.com
```

**Options lors de la configuration :**
- Choisir entre HTTPS ou SSH pour les opérations Git
- Se connecter à GitHub.com ou à une instance Enterprise
- Authentification via navigateur (plus sécurisé)

### Vérifier l'état de l'authentification
```bash
# Voir le statut de l'authentification
gh auth status

# Voir le statut pour un hôte spécifique
gh auth status --hostname github.enterprise.com

# Afficher le token (attention!)
gh auth status --show-token
```

### Se déconnecter
```bash
gh auth logout
```

## Gestion des Repositories

### Créer un repository
```bash
# Créer interactivement
gh repo create

# Créer un repository public avec clone automatique
gh repo create mon-projet --public --clone

# Créer un repository privé
gh repo create mon-projet --private

# Créer depuis le répertoire courant
gh repo create mon-projet --private --source=. --remote=origin

# Créer dans une organisation
gh repo create mon-org/mon-projet --public

# Créer avec README, .gitignore et licence
gh repo create mon-projet --public --add-readme --gitignore=Python --license=MIT
```

### Cloner un repository
```bash
# Cloner via HTTPS (par défaut)
gh repo clone proprietaire/repo

# Cloner via SSH
gh repo clone proprietaire/repo -- --ssh

# Cloner dans un dossier spécifique
gh repo clone proprietaire/repo mon-dossier
```

### Lister les repositories
```bash
# Vos repositories
gh repo list

# Repositories d'une organisation
gh repo list mon-org

# Avec limite
gh repo list --limit 50

# Filtrer par topic
gh repo list --topic python

# Format JSON
gh repo list --json name,description,visibility
```

### Fork un repository
```bash
# Fork dans votre compte
gh repo fork proprietaire/repo

# Fork dans une organisation
gh repo fork proprietaire/repo --org mon-org

# Fork et clone
gh repo fork proprietaire/repo --clone

# Fork sans clone
gh repo fork proprietaire/repo --remote=false
```

### Voir les détails d'un repository
```bash
# Informations sur le repo courant
gh repo view

# Informations sur un repo spécifique
gh repo view proprietaire/repo

# Ouvrir dans le navigateur
gh repo view --web

# Voir les détails en JSON
gh repo view --json name,description,stargazersCount,forksCount
```

### Supprimer un repository
```bash
# Supprimer le repository courant (avec confirmation)
gh repo delete

# Supprimer un repo spécifique
gh repo delete proprietaire/repo --yes
```

## Gestion des Pull Requests

### Créer une pull request
```bash
# Créer interactivement
gh pr create

# Créer avec titre et body
gh pr create --title "Fix: Correction du bug de connexion" --body "Cette PR corrige le problème de timeout"

# Créer en brouillon
gh pr create --draft --title "WIP: Nouvelle fonctionnalité"

# Créer avec assignation
gh pr create --assignee @me --title "Ma PR"

# Créer avec reviewers
gh pr create --reviewer alice,bob --reviewer mon-org/team-dev

# Créer avec labels
gh pr create --label bug --label "priority:high"

# Créer vers une branche spécifique
gh pr create --base develop --head feature-branch

# Utiliser un template
gh pr create --template .github/pull_request_template.md

# Utiliser les infos du commit
gh pr create --fill

# Ouvrir dans le navigateur
gh pr create --web
```

### Lister les pull requests
```bash
# Lister les PR ouvertes
gh pr list

# Lister toutes les PR
gh pr list --state all

# Lister les PR fermées
gh pr list --state closed

# Lister les PR fusionnées
gh pr list --state merged

# Filtrer par auteur
gh pr list --author @me

# Filtrer par assignee
gh pr list --assignee alice

# Filtrer par label
gh pr list --label bug --label "help wanted"

# Limiter le nombre de résultats
gh pr list --limit20

# Recherche avancée
gh pr list --search "status:success review:required"

# Voir dans le navigateur
gh pr list --web
```

### Voir les détails d'une PR
```bash
# Voir la PR courante
gh pr view

# Voir une PR spécifique
gh pr view 123

# Voir avec les commentaires
gh pr view 123 --comments

# Ouvrir dans le navigateur
gh pr view --web

# Format JSON
gh pr view 123 --json number,title,body,author,state
```

### Checkout une PR
```bash
# Checkout la PR localement
gh pr checkout 123

# Checkout et créer une branche nommée
gh pr checkout 123 --branch ma-branche-pr

# Force le checkout (écrase les changements locaux)
gh pr checkout 123 --force
```

### Merger une PR
```bash
# Merger avec la méthode par défaut
gh pr merge 123

# Merger avec squash
gh pr merge 123 --squash

# Merger avec rebase
gh pr merge 123 --rebase

# Merger et supprimer la branche
gh pr merge 123 --delete-branch

# Merger avec un message personnalisé
gh pr merge 123 --subject "fix(auth): correction login" --body "Description détaillée"

# Activer l'auto-merge
gh pr merge 123 --auto

# Annuler l'auto-merge
gh pr merge 123 --disable-auto

# Merger en utilisant les privilèges admin
gh pr merge 123 --admin
```

### Commenter une PR
```bash
# Ajouter un commentaire
gh pr comment 123 --body "LGTM! 👍"

# Commenter depuis un fichier
cat commentaire.md | gh pr comment 123 --body-file -
```

### Fermer une PR
```bash
gh pr close 123

# Fermer et supprimer la branche
gh pr close 123 --delete-branch
```

### Mettre à jour une PR
```bash
# Rafraîchir la branche
gh pr update-branch 123
```

## Gestion des Issues

### Créer une issue
```bash
# Créer interactivement
gh issue create

# Créer avec titre et body
gh issue create --title "Bug: Crash au démarrage" --body "Description du problème..."

# Créer avec labels
gh issue create --label bug --label "priority:high"

# Créer avec assignation
gh issue create --assignee @me

# Créer dans un projet
gh issue create --project "Sprint 12"

# Créer avec milestone
gh issue create --milestone "v2.0"

# Ouvrir dans le navigateur
gh issue create --web
```

### Lister les issues
```bash
# Lister les issues ouvertes
gh issue list

# Lister toutes les issues
gh issue list --state all

# Lister les issues fermées
gh issue list --state closed

# Filtrer par label
gh issue list --label bug

# Filtrer par assignee
gh issue list --assignee @me

# Filtrer par auteur
gh issue list --author alice

# Recherche avancée
gh issue list --search "crash in:title"

# Limiter les résultats
gh issue list --limit 50
```

### Voir une issue
```bash
gh issue view 123

# Avec les commentaires
gh issue view 123 --comments

# Ouvrir dans le navigateur
gh issue view 123 --web
```

### Commenter une issue
```bash
gh issue comment 123 --body "Je regarde ce problème"
```

### Fermer/Rouvrir une issue
```bash
# Fermer
gh issue close 123

# Fermer avec commentaire
gh issue close 123 --comment "Corrigé dans la PR #456"

# Rouvrir
gh issue reopen 123
```

### Développement lié
```bash
# Créer une branche pour une issue
gh issue develop 123 --checkout

# Créer une branche nommée différemment
gh issue develop 123 --base main --branch fix-issue-123
```

## Releases

### Créer une release
```bash
# Créer interactivement
gh release create

# Créer avec tag
gh release create v1.0.0

# Créer avec tag et titre
gh release create v1.0.0 --title "Version 1.0.0"

# Créer avec notes générées automatiquement
gh release create v1.0.0 --generate-notes

# Créer avec notes manuelles
gh release create v1.0.0 --notes "Nouvelles fonctionnalités..."

# Créer depuis un fichier
gh release create v1.0.0 --notes-file CHANGELOG.md

# Créer en pré-release
gh release create v1.0.0 --prerelease

# Créer en version finale
gh release create v1.0.0 --latest

# Créer avec des fichiers joints
gh release create v1.0.0 app.zip installer.msi

# Créer sur une cible spécifique
gh release create v1.0.0 --target main
```

### Lister les releases
```bash
gh release list

# Limiter les résultats
gh release list --limit 10
```

### Télécharger une release
```bash
# Télécharger un asset spécifique
gh release download v1.0.0 --pattern "*.zip"

# Télécharger tous les assets
gh release download v1.0.0

# Télécharger vers un dossier spécifique
gh release download v1.0.0 --dir ./downloads
```

### Supprimer une release
```bash
gh release delete v1.0.0

# Supprimer sans confirmation
gh release delete v1.0.0 --yes
```

## Workflows GitHub Actions

### Lister les workflows
```bash
gh workflow list

# Voir tous les workflows (même désactivés)
gh workflow list --all
```

### Voir un workflow
```bash
# Voir les détails
gh workflow view ci.yml

# Voir par ID
gh workflow view 1234567

# Ouvrir dans le navigateur
gh workflow view ci.yml --web
```

### Exécuter un workflow
```bash
# Exécuter manuellement
gh workflow run ci.yml

# Exécuter avec des inputs
gh workflow run deploy.yml -f environnement=production -f version=1.2.3

# Exécuter sur une branche spécifique
gh workflow run ci.yml --ref feature-branch
```

### Voir les runs
```bash
# Voir les exécutions récentes
gh run list

# Filtrer par workflow
gh run list --workflow=ci.yml

# Filtrer par branche
gh run list --branch=main

# Filtrer par statut
gh run list --status=success
gh run list --status=failure

# Limiter les résultats
gh run list --limit20
```

### Voir les logs d'un run
```bash
# Voir les détails
gh run view 1234567890

# Voir les logs
gh run view 1234567890 --log

# Voir uniquement les jobs échoués
gh run view 1234567890 --log-failed

# Ouvrir dans le navigateur
gh run view 1234567890 --web
```

### Watch un run
```bash
# Suivre l'exécution en temps réel
gh run watch 1234567890

# Suivre avec intervalle personnalisé (secondes)
gh run watch 1234567890 --interval 10
```

### Supprimer un run
```bash
gh run delete 1234567890
```

## Gists

### Créer un gist
```bash
# Créer depuis un fichier
gh gist create script.py

# Créer avec description
gh gist create script.py --desc "Script utile pour parser des logs"

# Créer public
gh gist create script.py --public

# Créer depuis stdin
cat data.json | gh gist create -
```

### Lister les gists
```bash
gh gist list

# Limiter les résultats
gh gist list --limit 20
```

### Voir un gist
```bash
# Voir le contenu
gh gist view GIST_ID

# Voir les fichiers
gh gist view GIST_ID --files

# Ouvrir dans le navigateur
gh gist view GIST_ID --web
```

### Éditer un gist
```bash
gh gist edit GIST_ID

# Éditer un fichier spécifique
gh gist edit GIST_ID --filename script.py
```

### Supprimer un gist
```bash
gh gist delete GIST_ID
```

## Alias et Configuration

### Créer des alias
```bash
# Créer un alias pour les PR
gh alias set prs 'pr list --author @me --state open'

# Utiliser l'alias
gh prs

# Liste des alias
gh alias list

# Supprimer un alias
gh alias delete prs
```

### Configuration
```bash
# Voir la configuration
gh config list

# Définir l'éditeur par défaut
gh config set editor vim

# Définir le protocole Git
gh config set git_protocol ssh

# Définir le prompt
gh config set prompt enabled
```

## Exemples de Workflows GitHub Actions

### Workflow de Test Basique
```yaml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v5
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint
    
    - name: Run tests
      run: npm test
```

### Workflow Multi-Plateforme (Matrix)
```yaml
name: Tests Matrix

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: ['18.x', '20.x', '22.x']
    
    steps:
    - uses: actions/checkout@v5
    
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
    
    - run: npm ci
    - run: npm test
```

### Build et Push Docker
```yaml
name: Build and Push Docker

on:
  push:
    branches: [main]
    tags: ['v*']

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      attestations: write
      id-token: write
    
    steps:
    - name: Checkout
      uses: actions/checkout@v5
    
    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
    
    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
```

### Workflow Python avec uv
```yaml
name: Python CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v5
    
    - name: Install uv
      uses: astral-sh/setup-uv@v3
      with:
        version: 'latest'
    
    - name: Setup Python
      run: uv python install 3.12
    
    - name: Install dependencies
      run: uv sync --all-extras --dev
    
    - name: Run linter
      run: uvx ruff check .
    
    - name: Run type checker
      run: uvx mypy src/
    
    - name: Run tests
      run: uv run pytest
```

### Workflow de Release Automatique
```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    
    steps:
    - uses: actions/checkout@v5
    
    - name: Create Release
      uses: softprops/action-gh-release@v1
      with:
        generate_release_notes: true
        files: |
          dist/*.whl
          dist/*.tar.gz
```

## Bonnes Pratiques

### Pour les PR
1. **Créer des PR petites et focalisées** - Plus faciles à reviewer
2. **Utiliser des templates de PR** - Standardiser la description
3. **Assigner des reviewers rapidement** - Ne pas attendre
4. **Utiliser les labels** - Faciliter le tri
5. **Lier aux issues** - Closes #123 dans la description

### Pour les Issues
1. **Utiliser des templates** - Bug report, feature request
2. **Labelliser systématiquement** - bug, enhancement, documentation
3. **Assigner rapidement** - Éviter les issues orphelines
4. **Utiliser les milestones** - Organiser par version/sprint
5. **Fermer les issues résolues** - Maintenir la liste propre

### Pour GitHub Actions
1. **Utiliser des versions spécifiques** - actions/checkout@v5 au lieu de @main
2. **Limiter les permissions** - Principle of least privilege
3. **Utiliser des secrets** - Jamais de credentials en dur
4. **Mettre en cache** - npm, pip, cargo pour accélérer
5. **Tester localement** - Avec act ou nektos/act

### Sécurité
1. **Ne jamais committer de secrets** - Utiliser GitHub Secrets
2. **Activer 2FA** - Sur votre compte GitHub
3. **Vérifier les actions tierces** - Avant de les utiliser
4. **Scanner les dépendances** - Dependabot alerts
5. **Utiliser des tokens à durée limitée** - Pour l'automatisation
