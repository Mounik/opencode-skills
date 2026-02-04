# Skills Personnels pour OpenCode

Une collection de skills personnalisés pour **OpenCode** et autres assistants IA, inspirée de [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills).

## 🎯 Objectif

Ce projet vous permet de créer et gérer vos propres **skills** - des fichiers de connaissances spécialisés qu'OpenCode peut utiliser pour mieux vous assister dans des domaines spécifiques.

## 📁 Structure

```
.
├── AGENTS.md              # Directives pour les agents IA
├── README.md              # Ce fichier
├── mon-skill-1/           # Vos skills personnels
│   └── SKILL.md
├── mon-skill-2/
│   └── SKILL.md
├── .agent/skills/         # Collection antigravity (référence uniquement)
│   └── skills/
│       ├── nextjs-best-practices/
│       ├── api-design-principles/
│       └── ... (626+ skills)
├── .opencode/skills/      # Skills OpenCode (projet)
│   └── <skill-name>/
│       └── SKILL.md
└── .claude/skills/        # Compatible Claude Code (optionnel)
    └── <skill-name>/
        └── SKILL.md
```

## 🚀 Commencer

### Créer votre premier skill avec OpenCode

```bash
# Utiliser le CLI OpenCode pour créer un nouveau skill
opencode agent create
```

Cette commande interactive vous guide pour :
- Choisir où sauvegarder le skill (global ou projet)
- Définir la description du skill
- Générer un prompt système approprié
- Sélectionner les outils accessibles

### Création manuelle

```bash
# Créer un dossier pour votre skill dans .opencode/skills/
mkdir -p .opencode/skills/mon-skill-perso

# Créer le fichier SKILL.md
cat > .opencode/skills/mon-skill-perso/SKILL.md << 'EOF'
---
name: mon-skill-perso
description: "Description de ce que fait mon skill"
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: general
---

# Mon Skill Perso

## Ce que je fais

- Description des fonctionnalités du skill
- Liste des tâches que le skill peut accomplir

## Quand m'utiliser

- Utiliser quand vous travaillez sur [votre projet spécifique]
- Utiliser quand vous devez [tâche spécifique]

## Instructions

Vos instructions détaillées ici...

## Exemples

```bash
# Exemple de commande
votre-commande-ici
```
EOF
```

### Structure d'un skill

Chaque skill est un dossier contenant un fichier `SKILL.md` :

```markdown
---
name: nom-du-skill
description: "Description en une ligne"
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: general
---

# Titre du Skill

## Ce que je fais

- Fonctionnalité 1
- Fonctionnalité 2

## Quand m'utiliser

- Utiliser quand [scénario 1]
- Utiliser quand [scénario 2]

## Instructions

Étapes détaillées...

## Exemples

```language
exemple de code
```
```

## 📚 Inspiration

Le dossier `.agent/skills/` contient une collection de **626+ skills** couvrant :

- **Frontend** : React, Vue, Angular, Next.js, Tailwind
- **Backend** : Node.js, Python, Go, Rust, APIs
- **DevOps** : Docker, Kubernetes, CI/CD, Terraform
- **Mobile** : React Native, Flutter, iOS, Android
- **Data** : SQL, NoSQL, Data Engineering, ML
- **Security** : Pentesting, Sécurité applicative, Conformité
- **Soft Skills** : Communication, Gestion de projet, Documentation

Consultez ces skills pour vous inspirer et comprendre les bonnes pratiques !

## 📝 Conventions

### Emplacements des Skills

OpenCode recherche les skills dans ces emplacements (par ordre de priorité) :

1. **Projet spécifique** : `.opencode/skills/<name>/SKILL.md`
2. **Global** : `~/.config/opencode/skills/<name>/SKILL.md`
3. **Compatible Claude (projet)** : `.claude/skills/<name>/SKILL.md`
4. **Compatible Claude (global)** : `~/.claude/skills/<name>/SKILL.md`

### Nommage
- **Dossiers** : `kebab-case` (ex: `mon-skill`, `api-interne`)
- **Nom dans le fichier** : Doit correspondre exactement au dossier
- **Fichier principal** : Toujours nommé `SKILL.md`

### Contenu requis
1. **Frontmatter YAML** avec `name` et `description`
2. **Section "Ce que je fais"** pour décrire les fonctionnalités
3. **Section "Quand m'utiliser"** pour décrire les cas d'usage
4. **Exemples concrets** que l'IA peut suivre
5. **Instructions claires** et actionnables

### Commits Git
```bash
feat: ajouter skill pour mon api interne
docs: améliorer les exemples de react-hooks
fix: corriger typo dans les commandes git
```

## 🎓 Exemples de Skills Utiles

### Skill pour votre stack technique interne
```markdown
---
name: ma-stack-interne
description: "Stack technique et conventions de mon entreprise"
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: development
---

# Stack Interne

## Ce que je fais

- Guide pour créer des projets avec la stack interne
- Définit les conventions de code et architecture

## Quand m'utiliser

- Utiliser quand vous créez un nouveau projet
- Utiliser quand vous configurez l'authentification

## Stack

- **Frontend** : React + TypeScript + Tailwind
- **Backend** : Node.js + Express + Prisma
- **Base de données** : PostgreSQL
- **Déploiement** : Docker + GitHub Actions

## Conventions

### Structure des projets
```
src/
├── components/     # Composants React
├── hooks/         # Custom hooks
├── lib/           # Utilitaires
└── types/         # Types TypeScript
```

### Nommage
- Composants : PascalCase
- Hooks : camelCase avec préfixe `use`
- Utilitaires : camelCase
```

### Skill pour vos scripts fréquents
```markdown
---
name: mes-scripts-utiles
description: "Scripts et commandes que j'utilise fréquemment"
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: deployment
---

# Scripts Utiles

## Ce que je fais

- Fournit des commandes de déploiement rapides
- Automatise le nettoyage des branches git

## Quand m'utiliser

- Utiliser pour déployer rapidement
- Utiliser pour nettoyer les branches git

## Déploiement

```bash
# Build et push
docker build -t mon-app .
docker push mon-app:latest
kubectl rollout restart deployment/mon-app
```

## Git

```bash
# Nettoyer les branches mergées
git branch --merged | grep -v "\*" | xargs -n1 git branch -d
```
```

## 📖 Ressources

- [AGENTS.md](./AGENTS.md) - Directives détaillées pour créer des skills
- [.agent/skills/skills/](./.agent/skills/skills/) - Collection de référence (626+ skills)
- [OpenCode Documentation](https://opencode.ai/docs) - Documentation officielle d'OpenCode
- [OpenCode Skills Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/skills.mdx) - Guide des skills
- [OpenCode Agents Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/agents.mdx) - Guide des agents

## 🔧 Astuces

1. **Commencez simple** : Créez un skill basique et améliorez-le au fil du temps
2. **Soyez spécifique** : Plus vos instructions sont précises, mieux l'IA pourra vous aider
3. **Testez** : Utilisez le skill avec OpenCode et ajustez selon les résultats
4. **Versionnez** : Commitez régulièrement vos modifications

## 🤖 Agents et Sous-agents

OpenCode supporte la création d'agents et de sous-agents via `opencode agent create`.

### Configuration des Agents (opencode.json)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "tools": {
        "write": false,
        "edit": false
      }
    }
  }
}
```

**Modes d'agents** :
- `primary` : Agent principal avec accès complet
- `subagent` : Sous-agent avec permissions restreintes

## 📄 License

Ce projet est destiné à un usage personnel. Les skills dans `.agent/skills/` proviennent de [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) sous licence MIT.
